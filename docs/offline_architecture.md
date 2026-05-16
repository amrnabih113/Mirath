# Mirath Offline-First Architecture

This document summarizes the final offline-first, stale-while-revalidate caching
architecture implemented for Mirath. It includes design rationales, components,
data flow diagrams (textual), and implementation guidance.

---

1) Goals

- Instant UI using cached data on startup
- Stale-while-revalidate reads
- Optimistic writes with retry queue
- Offline messaging with queued sends
- Centralized error mapping and retry strategy

2) Core Concepts

- In-memory: Cubit/Bloc state — fastest, session-scoped
- Hive: persistent cache and persistent retry queue
- Remote API: truth source
# Mirath Offline-First Architecture (detailed)

This document provides a comprehensive reference for the offline-first,
stale-while-revalidate architecture implemented in Mirath. It documents the
purpose, public API, and rationale for each core class and method that
implements caching, synchronization, retry, and optimistic update behavior.

Use this document as both reference and onboarding material when adding new
features that must be resilient to network interruptions or provide near-
instant UI feedback.

---

**Scope**: The classes and methods below focus on the core primitives used by
features across the app. They are intentionally implementation-focused (Dart
/ Hive / Bloc/Cubit) and describe both the *why* and *how* for maintainers.

**Primary goals recap**:
- Fast UI by loading cached data immediately
- Stale-While-Revalidate reads to avoid blocking the UI
- Optimistic writes with persistent retry queue and reconciliation
- Durable offline messaging with dedupe (clientId)
- Centralized error mapping to domain `Failure` objects

---

**Contents (quick links)**
- `FetchPolicy` and `Resource<T>` (read semantics)
- `RepositoryBase` (fetchWithCache implementation)
- `HiveCacheService` and `CacheRecord` (persistence primitives)
- `CacheKeys` and `CacheNotifier` (keying & change notification)
- `RetryQueue`, `RetryQueueItem`, `HiveRetryQueue` (durable queue API)
- `SyncManager` and `RetryService` (processing, backoff, handlers)
- Network and API helpers (`NetworkManager`, `DioClient`) — usage notes
- Patterns: optimistic updates, reconciliation by `clientId`
- Examples and migration guidance

---

**FetchPolicy (lib/core/api/fetch_policy.dart)**

- Purpose: Provide a small enum describing the allowed source and fallbacks
  when reading data. Repositories use this to decide whether to read cache,
  call the network, or both.

- Values and rationale:
  - `cacheOnly` — Read only from cache. Useful for background-only tasks or
    when the UI must not block on the network and stale data is acceptable.
  - `networkOnly` — Always contact remote; do not persist to cache unless the
    caller explicitly wants to. Useful for actions that must reflect server
    truth and are not cachable.
  - `cacheFirst` — Prefer cache but refresh in background. Good for lists
    where eventual freshness is acceptable.
  - `staleWhileRevalidate` — Return cache immediately (if present) and then
    fetch remote in background; transparently persist and notify when fresh
    data arrives. Default for most read-heavy UI views.
  - `networkFirst` — Try remote and fall back to stale cache on errors. Useful
    for views that should prefer fresh data but still show something offline.

**Why**: Centralizes read semantics so feature repositories behave uniformly.

---

**Resource<T> (lib/core/api/resource.dart)**

- Shape: `Resource` wraps the result of `fetchWithCache` and encodes status.
  - `ResourceStatus` — `loading`, `success`, `error`
  - `T? data` — the deserialized payload when available
  - `Failure? failure` — domain failure when an error occurred
  - `bool fromCache` — true when data was loaded from cache

- Factory helpers: `Resource.loading()`, `Resource.success(data, fromCache)`,
  `Resource.error(failure)`

**Why**: Enables repositories to surface not only data or errors but whether
the data came from cache. `fromCache` is used by UI to render subtle badges
(e.g., "cached") and to avoid re-showing loading spinners when showing
cached content.

---

**RepositoryBase (lib/core/api/repository_base.dart)**

- Type: `mixin RepositoryBase` exposing one primary helper:

  Future<Resource<T>> fetchWithCache<T>({
    required String cacheKey,
    required Future<T> Function() fetchRemote,
    required T Function(dynamic json) fromJson,
    FetchPolicy policy = FetchPolicy.staleWhileRevalidate,
    Duration? ttl,
  })

- Behavior (step-by-step):
  1. If policy allows cache reads (`cacheOnly`, `cacheFirst`,
     `staleWhileRevalidate`), attempt `cacheService.getJson(cacheKey,
     allowStale:true)`.
     - If cached JSON present: deserialize via `fromJson` and return
       `Resource.success(model, fromCache: true)`.
     - If policy == `staleWhileRevalidate` or `cacheFirst`, schedule a
       background `fetchRemote()` to refresh the cache (fire-and-forget).
  2. If no cache or policy forces remote (`networkOnly`, `networkFirst`,
     `networkOnly`), call `fetchRemote()`.
     - On success persist to cache (`cacheService.putJson(cacheKey, remote.toJson(), ttl)`)
       and return `Resource.success(remote, fromCache:false)`.
     - On error, if allowed, try fallback to stale cache (for
       `networkFirst`) else return `Resource.error(mapExceptionToFailure(e))`.

- Requirements for callers:
  - `cacheService` getter must be implemented by the class using the mixin.
  - `fetchRemote()` should return the concrete model type and provide a
    `.toJson()` if it is to be persisted.

**Why**: Encapsulates the repeated stale-while-revalidate pattern so feature
repositories only supply a cache key, remote call, and JSON (de)serialization.
It avoids duplication and ensures uniform TTL usage and failure handling.

**How to use**: Implementing repositories should `with RepositoryBase` and
expose a `HiveCacheService get cacheService => _cacheService;` then call
`fetchWithCache(...)` returning `Resource<T>` and mapping to domain results
(`Either<Failure,T>`) as appropriate.

---

**HiveCacheService (lib/core/cache/hive_cache_service.dart)**

- Responsibility: Persistent JSON storage with TTL support and list helpers.
  It stores serialized JSON (Map<String, dynamic>) wrapped in a
  `CacheRecord` containing creation timestamp and optional expiry.

- Key public methods and intent:
  - `Future<void> putJson(String key, Map<String,dynamic> json, {Duration? ttl})`
    Persist a JSON object. TTL if provided is converted into an expiry.
  - `Future<Map<String,dynamic>?> getJson(String key, {bool allowStale=false})`
    Load persisted JSON. If expired and `allowStale==false` return `null`.
    If `allowStale==true` return expired data for S-W-R flows.
  - `Future<void> putJsonList(String key, List<Map<String,dynamic>> list, {Duration? ttl})`
    Persist a list payload (e.g., paginated list of papers).
  - `Future<List<Map<String,dynamic>>?> getJsonList(String key, {bool allowStale=false})`
    Load list payload with TTL semantics.
  - `Future<void> upsertInJsonList(String key, Map<String,dynamic> item, String idField)`
    Upsert item by `idField` within stored list JSON; create list if missing.
  - `Future<void> removeFromJsonList(String key, String id, String idField)`
    Remove a matching item from a stored list.
  - `Future<void> updateJsonListItem(String key, String id, String idField, Map<String,dynamic> patch)`
    Patch an item in the list without full overwrite.
  - `Future<void> updateJsonListItemsByPrefix(String prefix, Map<String,dynamic> patch)`
    Bulk update list items whose cache keys share a prefix (helpful for
    list→item sync flows).
  - `Future<void> removeJsonListItemsByPrefix(String prefix)`
    Remove cached lists when a top-level change invalidates many lists.

- Internal types:
  - `CacheRecord` — shape: `{data: Map, createdAt: String, expiresAt: String?}`
    The service stores this wrapper to evaluate TTL on reads.

**Why**: Hive stores typed Dart objects; keeping JSON payloads (not model
instances) decouples persistence from domain models and avoids adapter churn.

**Practical notes**:
- Always call `CacheNotifier.instance.notify(key)` after `putJson` or
  `putJsonList` to allow subscribers (Cubits) to react to fresh data.
- Prefer `allowStale: true` when implementing S-W-R reads in
  `RepositoryBase.fetchWithCache` so the UI is not blocked by expiry.

---

**CacheKeys (lib/core/cache/cache_keys.dart)**

- Purpose: Centralize generation of stable cache keys to avoid mismatches
  across features. Examples include `paperById(id)`, `discussionById(id)`,
  `readingLists(...)`.

**Why**: Single source-of-truth for keys prevents subtle bugs where code
writing to `paper:123` and reading `paper-id=123` would miss updates.

---

**CacheNotifier (lib/core/cache/cache_notifier.dart)**

- Purpose: Lightweight pub/sub used by Cubits and features to subscribe to
  cache changes for a specific key or prefix. Implemented as a singleton
  with `subscribe(key)` / `unsubscribe(subscription)` and `notify(key)`.

- Usage pattern:
  - Repositories call `CacheNotifier.instance.notify(cacheKey)` after a
    successful `putJson` to surface fresh data.
  - Cubits subscribe at init: `CacheNotifier.instance.subscribe(key, () => _reloadFromCache())`

**Why**: Avoids polling and provides deterministic updates when background
revalidation completes.

---

**RetryQueue API (lib/core/sync/retry_queue.dart)**

- Purpose: Durable representation of pending operations that must be
  retried (optimistic writes, message sends). The interface is intentionally
  minimal so implementations can be backed by Hive, SQLite, or other stores.

- Core contract (essential methods):
  - `Future<void> add(RetryQueueItem item)` — append a new item
  - `Future<List<RetryQueueItem>> getAll()` — enumerate pending items
  - `Future<void> remove(String id)` — remove processed item
  - `Future<void> update(RetryQueueItem item)` — update attempts/metadata

**RetryQueueItem (lib/core/sync/retry_queue_item.dart)**

- Fields (typical):
  - `String id` — persistent id of the queue entry
  - `String type` — operation type (e.g., `send_message`, `create_comment`)
  - `Map<String,dynamic> payload` — JSON-serializable payload for handler
  - `int attempts` — number of attempts performed
  - `DateTime? nextAttemptAt` — optional backoff scheduling
  - `String? clientId` — optional idempotency key used by messaging

**Why**: `attempts` and `nextAttemptAt` must be persisted so restarts
do not reset retry counters.

---

**HiveRetryQueue (lib/core/sync/hive_retry_queue.dart)**

- Implementation notes:
  - Uses a Hive box keyed by `retry_queue` to store `RetryQueueItem` JSON.
  - `add()` assigns a UUID if not provided and persists the record.
  - `getAll()` returns entries ordered by `nextAttemptAt` (null/oldest first)
  - `update()` overwrites the record and increments attempts when a handler
    is executed.

**Why**: Hive provides quick, file-backed persistence that survives app
crashes and restarts. Using JSON preserves portability and avoids generated
type adapters for every queue item.

---

**SyncManager (lib/core/sync/sync_manager.dart)**

- Responsibility: Coordinate background processing of queued items and
  executing registered handlers for each `type`.

- Public API:
  - `void registerHandler(String type, Future<RetryHandlerResult> Function(RetryQueueItem) handler)`
    Register a function responsible for executing one queue item and
    returning success/failure and optional server-side payload.
  - `Future<void> start()` — start listening to `NetworkManager` and
    begin processing when connected.
  - `Future<void> stop()` — stop background processing.
  - `Future<void> processOnce()` — process the queue immediately (used by
    unit tests or manual triggers).

- Processing behavior:
  - Subscribe to `NetworkManager.connectionStream` and when `connected==true`
    call `processOnce()`.
  - `processOnce()` loads items from `RetryQueue.getAll()` and for each
    item:
    1. If `nextAttemptAt` in future, skip.
    2. Call the registered handler for `item.type`.
    3. If handler succeeds: merge server payload into cache (if returned),
       remove item from queue.
    4. If transient error: increment `attempts`, compute exponential backoff
       `nextAttemptAt = now + baseDelay * 2^attempts + jitter`, persist via
       `retryQueue.update(item)`.
    5. If permanent error or `attempts >= maxAttempts`: remove or mark
       as failed and optionally surface UI action.

**Why**: Centralizing retry/backoff keeps behavior consistent and simplifies
adding new queued action types — a handler only needs to implement the
operation and reconciliation logic, not the retry loop.

---

**RetryService (lib/core/sync/retry_service.dart)**

- Convenience wrapper used by UI/Cubit code to enqueue optimistic
  operations. Typical usage: `sl<RetryService>().enqueue(type, payload, clientId: ...)`.

- Responsibilities:
  - Create `RetryQueueItem` with a new id and `attempts=0`.
  - Persist to `RetryQueue.add()`.
  - Optionally call `SyncManager.processOnce()` to prompt immediate
    processing when helpful (e.g., after enqueue while connected).

**Why**: Keeps enqueueing logic and queue schema centralized and testable.

---

**NetworkManager & DioClient (notes)**

- `NetworkManager` (connectivity_plus) exposes:
  - `Future<bool> get isConnected` — current connectivity state
  - `Stream<ConnectivityStatus> get connectionStream` — live updates

- `DioClient` wraps Dio to add auth headers, interceptors, and a standard
  `post/get/put/delete` wrapper. Important for offline flows:
  - Handlers should catch Dio errors and allow `mapExceptionToFailure` to
    convert them into domain `Failure` objects (e.g., `NetworkFailure`,
    `ServerFailure`).
  - For idempotent operations (messages, create_comment), include `clientId`
    in payload so the server can deduplicate and return canonical IDs.

**Why**: Making network behavior deterministic and centralized reduces
duplication and eases error mapping for `RepositoryBase` and `SyncManager`.

---

**Optimistic Update & Messaging Patterns**

- Optimistic write high-level sequence:
  1. Cubit updates in-memory list with a local draft (id `local-<uuid>`),
     optionally setting `isPending=true`.
  2. Persist the draft into Hive with `upsertInJsonList` so it's durable.
  3. Enqueue a `RetryQueueItem` with `type` and `payload` (including
     `clientId` where needed).
  4. UI shows pending indicator.
  5. `SyncManager` executes handler; on success, handler upserts the server
     object into cache (by server id) and removes the local draft (matching
     by `clientId` or local id).

- Messaging reconciliation by `clientId`:
  - Messages include `clientId` (UUID) generated by client.
  - Server returns canonical `messageId` and echoes `clientId`.
  - Handler replaces persisted message (matching `clientId`) with the
    server-provided JSON and marks `status=sent`.

**Why**: This pattern provides immediate responsiveness while guaranteeing
eventual consistency and avoiding duplicates.

---

**Examples**

- `RepositoryBase.fetchWithCache` example (pseudocode):

```dart
final res = await fetchWithCache<FullPaperEntity>(
  cacheKey: CacheKeys.paperById(id),
  fetchRemote: () async => await remote.getPaperById(id),
  fromJson: (json) => FullPaperModel.fromJson(json).toEntity(),
  policy: FetchPolicy.staleWhileRevalidate,
);
if (res.status == ResourceStatus.success) return Right(res.data!);
if (res.failure != null) return Left(res.failure!);
return Left(ServerFailure());
```

- `SyncManager` handler example for `send_message` (pseudocode):

```dart
syncManager.registerHandler('send_message', (item) async {
  final payload = item.payload;
  final response = await dio.post('/messages', data: payload);
  // upsert server message in cache
  await cacheService.upsertInJsonList(CacheKeys.messages(conversationId), response.data, 'id');
  // remove local draft by clientId
  await cacheService.removeFromJsonList(CacheKeys.messages(conversationId), item.clientId, 'clientId');
  return RetryHandlerResult.success(response.data);
});
```

---

**Migration & Best Practices**

- When migrating a repository to `RepositoryBase.fetchWithCache`:
  1. Ensure the feature model has `fromJson(Map)` and `toJson()`.
  2. Add or reuse a `CacheKeys` entry for per-item and per-list caches.
  3. Implement the repository class with `with RepositoryBase` and a
     `HiveCacheService get cacheService => _cacheService;` getter.
  4. Replace remote-first reads with `fetchWithCache(..., policy: staleWhileRevalidate)`.
  5. After persisting remote response, call `CacheNotifier.instance.notify(cacheKey)`
     when the UI should react immediately.

- TTL guidance:
  - Short lived (30s-5m): feeds that change frequently (home feed)
  - Medium (10m-1h): search results, category lists
  - Long (1d+): user profile, static metadata

---

**Testing and Observability**

- Unit tests:
  - Use a `FakeRetryQueue` to verify `SyncManager` increments `attempts`,
    schedules `nextAttemptAt`, and removes succeeded items.
  - Test `RepositoryBase.fetchWithCache` flows by mocking `cacheService` —
    verify background `fetchRemote()` is triggered in S-W-R policy.

- Integration tests:
  - Use a temporary Hive box and a test Dio server to verify end-to-end
    optimistic message send, enqueue, worker processing, and reconciliation.

---

**Files of interest (reference)**

- `lib/core/api/fetch_policy.dart` — enum for policies
- `lib/core/api/resource.dart` — Resource wrapper
- `lib/core/api/repository_base.dart` — fetchWithCache implementation
- `lib/core/cache/hive_cache_service.dart` — cache operations
- `lib/core/cache/cache_notifier.dart` — cache change events
- `lib/core/cache/cache_keys.dart` — canonical cache key helpers
- `lib/core/sync/retry_queue.dart` — queue interface
- `lib/core/sync/hive_retry_queue.dart` — persistent queue
- `lib/core/sync/sync_manager.dart` — queue processor + handlers
- `lib/core/sync/retry_service.dart` — enqueue helper

---

If you'd like, I can:
1. Add concrete code snippets for each method in `HiveCacheService` and the
   `RetryQueue` implementation.
2. Run analyzer/tests after this change (I can run quick checks locally if
   you want me to execute). 
3. Continue migrating the remaining repositories to `RepositoryBase.fetchWithCache`.

Which of those would you like next?
