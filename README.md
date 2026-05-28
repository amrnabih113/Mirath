
# Mirath — Knowledge Preservation & Research Companion

Mirath (ميراث) is a production-grade academic social platform built for researchers and academics. It combines a structured research-paper library with a rich social layer: users can follow peers, create and share reading lists, annotate papers with color-coded XPath highlights, engage in threaded discussions, converse with an AI assistant that understands multi-modal input (text, images, and voice) with real-time streaming responses, and study papers with an AI assistant that can explain, summarize, and translate research content.

---

**Repository**: Mirath (Flutter)

Core app entry: [lib/main.dart](lib/main.dart#L1)

Dependency / DI root: [lib/injection/injection_container.dart](lib/injection/injection_container.dart#L1)

Router and route policy: [lib/app_router.dart](lib/app_router.dart#L1)

Network client & auth interceptor: [lib/core/network/dio_client.dart](lib/core/network/dio_client.dart#L1), [lib/core/network/dio_auth_interceptor.dart](lib/core/network/dio_auth_interceptor.dart#L1)

---

**Table of contents**
- Project Overview
- Features
- Tech Stack
- Architecture (detailed)
- State Management
- Authentication Flow
- API & Networking
- Local Storage & Caching
- Feature Modules (per major feature)
- UI / Design System
- Chatbot / AI integration
- Navigation & Deep linking
- Security considerations
- Performance optimizations
- Environment & Setup
- Running & Building
- Project structure (real tree)
- Important packages (why used)
- Developer onboarding (concise)
- Production readiness assessment
- conclusion

---

**Project Name + Overview**

Project name: Mirath

Overview
- Mirath is a knowledge preservation and research companion mobile/web app implemented in Flutter. Users can browse and search papers, annotate and highlight, create reading lists, participate in discussions, and use an integrated chatbot for research-related questions. The app targets researchers, students, and knowledge workers.
- Primary runtime targets are Android, iOS and Web (CI includes a Firebase Hosting web deployment workflow: [.github/workflows](.github/workflows/firebase-hosting-merge.yml)).

Who it's for
- Researchers, academics, and serious readers who need to curate, annotate, discuss, and retrieve research content.

---

**Features**

- Core reading & discovery
	- Search and browse recent papers, categories, and recommendations. (Home module)
	- Paper details and full reading UI with annotations. (Paper + Paper Annotations)

- Content curation
	- Save/unsave papers, reading lists creation and sharing, reading history. (Reading Lists, Library)

- Social / community
	- Discussions, comments, voting, and community search. (Community / Discussions module)

- Profile & Onboarding
	- Multi-step onboarding; profile setup and interest selection. (Onboarding, Profile)

- AI / Chatbot
	- Chatbot with file uploads and server-streaming (SSE) support. Uses server-side streaming endpoints and supports audio/image uploads. (features/chatbot)

- Local-first & offline resilience
	- Hive-based cache service with TTL, retry queue & sync manager for queued offline operations. (core/cache, core/sync)

- Platform niceties
	- Google Sign-In support, deep linking handling, native web hosting via Firebase (CI). (Auth + CI)

---

**Tech Stack**

| Area | Technology / Package |
|---|---|
| Flutter | stable channel (project targets cross-platform mobile & web) |
| Dart SDK | ^3.10.0 (pubspec environment) |
| State management | bloc, flutter_bloc, equatable |
| Dependency injection | get_it (service locator) |
| Routing | go_router |
| Networking | dio, dio_cookie_manager, cookie_jar |
| Storage / cache | hive, shared_preferences, flutter_secure_storage |
| Authentication | google_sign_in, backend session cookie-based refresh |
| File & media | image_picker, image_cropper, record, webview_flutter |
| Localization | flutter_localizations, intl, intl_utils |
| Logging | logger (MyLogger wrapper in core/utils) |
| CI / Hosting | GitHub Actions + Firebase Hosting (web) |

Refer to `pubspec.yaml` for full dependency list: [pubspec.yaml](pubspec.yaml#L1)

---

**Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  (UI / Cubits / State Management / Navigation)              │
│                                                             │
│  ┌──────────────┬──────────────┬──────────────┐             │
│  │   Screens    │   Widgets    │   Cubits     │             │
│  │  (Pages)     │  (UI Comps)  │  (BLoC/      │             │
│  │              │              │   State)     │             │
│  └──────────────┴──────────────┴──────────────┘             │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  (Business Logic / Use Cases / Entities)                    │
│                                                             │
│  ┌──────────────┬──────────────────┬──────────────┐         │
│  │  Entities    │   Repositories   │  UseCases    │         │
│  │  (Models)    │   (Interfaces)   │  (Logic)     │         │
│  │              │                  │              │         │
│  └──────────────┴──────────────────┴──────────────┘         │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  (API / Local Storage / Repositories Implementation)        │
│                                                             │
│  ┌──────────────┬──────────────┬──────────────┐             │
│  │Remote Data   │ Local Data   │Repository    │             │
│  │Sources       │ Sources      │Impl          │             │
│  │(Dio API)     │(Hive/Prefs)  │              │             │
│  └──────────────┴──────────────┴──────────────┘             │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                      CORE LAYER                             │
│  (Infrastructure / Cross-cutting concerns)                  │
│                                                             │
│  ┌──────────────┬──────────────┬──────────────┐             │
│  │ Network Mgr  │ Error Handler│ Cache Layer  │             │
│  │ (Dio/Cookies)│ (Exceptions/ │ (Hive/       │             │
│  │              │  Failures)   │  SharedPref) │             │
│  └──────────────┴──────────────┴──────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

High level
- The app uses a feature-first, layered architecture with Clean Architecture and reactive state management with BLoC. Major characteristics:
	- Feature-first folders under `lib/features/*` (e.g., `chatbot`, `auth`, `home`, `discussions`).
	- Each feature is split into `data`, `domain`, and `presentation` layers where present (typical Clean Architecture). See `features/chatbot` for an example.
	- Centralized dependency registration with GetIt in `lib/injection/injection_container.dart` which wires data sources, repositories, use cases, and cubits.
	- Repository pattern abstracts network/local storage behind use cases. Use cases are registered per feature and injected into Cubits.
	- State management is implemented with Cubits/BLoCs (`flutter_bloc`) for predictable state transitions.

Key files
- DI & Service registration: [lib/injection/injection_container.dart](lib/injection/injection_container.dart#L1)
- App router configuration and route guards: [lib/app_router.dart](lib/app_router.dart#L1)
- Network client and auth handling: [lib/core/network/dio_client.dart](lib/core/network/dio_client.dart#L1) and [lib/core/network/dio_auth_interceptor.dart](lib/core/network/dio_auth_interceptor.dart#L1)
- Cache & offline queue: [lib/core/cache/hive_cache_service.dart](lib/core/cache/hive_cache_service.dart#L1) and [lib/core/sync/sync_manager.dart](lib/core/sync/sync_manager.dart#L1)

ASCII architecture diagram 
```text
App
├─ lib/main.dart (bootstrap: NetworkManager, DI init, root cubits)
├─ lib/app_router.dart (GoRouter + auth redirects)
├─ lib/injection/injection_container.dart (GetIt service registration)
└─ features/
	 ├─ auth/
	 │  ├─ data/ (remote data source, models)
	 │  ├─ domain/ (entities, usecases)
	 │  └─ presentation/ (cubit, screens)
	 ├─ chatbot/  <-- SSE streaming + upload + cubit
	 ├─ home/
	 └─ ...
```
Data flow (example: send message via chatbot)
UI → Cubit (ChatbotCubit) → UseCase → Repository → RemoteDataSource (DioClient) → Backend

---

**State Management**

- Library: `bloc` + `flutter_bloc` with Cubits used widely. Cubits are registered in DI and provided where needed (see `lib/main.dart` and `lib/app_router.dart` where many `BlocProvider` or `BlocProvider.value` wrappers are created).
- State flows follow the standard unidirectional pattern: UI dispatches actions to Cubit → Cubit calls usecases → usecases call repository → repository interacts with remote/local sources → Cubit emits new state.

Files to inspect for state patterns: many cubits under `lib/features/*/presentation/cubit`. Example: `lib/features/chatbot/presentation/cubit/chatbot_cubit.dart`.

---

**Authentication Flow**

Observed behavior and implementation details:

- Sign-in / Sign-up
	- `features/auth/data/data_sources/auth_remote_data_source_impl.dart` calls backend endpoints (login, signup, verify, etc.). Login response may contain an `accessToken` which the app stores locally.
	- `AuthRepositoryImpl` persists `accessToken` using `SecureStorageService` and caches user info using `UserCacheService`.

- Token handling and refresh
	- The app uses `Dio` and an `AuthInterceptor` (`lib/core/network/dio_auth_interceptor.dart`) that injects `Authorization` headers for requests and reacts to 401 responses.
	- Refresh is implemented as a POST to the configured `refreshToken` endpoint; interceptor retries the original request on success and clears secure storage and triggers `AuthCubit.signOut()` on irreversible auth failures.
	- Refresh assumes server stores a refresh token in an HttpOnly cookie (the interceptor uses a cookie jar for non-web platforms and sends a refresh POST with `skipAuth: true`). See `DioClient` cookie jar setup at [lib/core/network/dio_client.dart](lib/core/network/dio_client.dart#L1).

- Social sign-in
	- Google Sign-In is implemented in `AuthRepositoryImpl` using `google_sign_in` and then exchanging the ID token with backend via `AuthRemoteDataSourceImpl.googleAuth`.

- Secure storage
	- Sensitive tokens and some state (email, setup-status) are stored with `flutter_secure_storage` by `SecureStorageService` (`lib/core/services/secure_storage_service.dart`).

- Session persistence
	- `AuthRepositoryImpl.isSignedIn()` uses secure storage to check for access token existence.

---

**API Layer**

Core client
- `lib/core/network/dio_client.dart` wraps `Dio` and provides typed `get/post/put/delete/patch/uploadFile` helpers and initializes interceptors.
- Cookie persistence via `PersistCookieJar` on mobile platforms; for web the client sets `withCredentials`.

Auth interceptor & error handling
- `lib/core/network/dio_auth_interceptor.dart` attaches access token, handles 401, retries using a refresh endpoint, employs retry/backoff for refresh attempts, and calls an `onAuthFailure` callback to clear local auth state when necessary.

Request lifecycle and serialization
- API responses are expected as JSON map structures; many remote data sources parse `resp.data as Map<String, dynamic>` and convert to models.

Interceptors & logging
- `Dio` is configured with `LogInterceptor` enabled during init to log requests/responses; `MyLogger` is used throughout the app for structured logs.

---

**Local Storage**

- `HiveCacheService` (lib/core/cache/hive_cache_service.dart) is the primary JSON cache with TTL support, upsert/remove helpers and list utilities. This is used heavily for caching lists (messages, discussions, papers) and enabling offline-first UX.
- `flutter_secure_storage` via `SecureStorageService` stores sensitive tokens and email.
- `shared_preferences` via `LocalStorageService` stores onboarding and lightweight flags (hasSeenOnboarding, profileSetup).
- `UserCacheService` wraps user-specific caching; see DI registration for `UserCacheService`.

  
**Hive Cache Service**

```dart
class HiveCacheService {
  // TTL-aware caching with auto-expiration
  Future<void> putJson(String key, Map<String, dynamic> payload, {
    Duration ttl = defaultTtl,
  });
  
  // Retrieve fresh or stale data
  Future<Map<String, dynamic>?> getJson(String key, {
    bool allowStale = false,
  });
  
  // List caching
  Future<void> putJsonList(String key, List<Map> items);
  Future<List<Map>?> getJsonList(String key, {bool allowStale});
  
  // Invalidation
  Future<void> delete(String key);
  Future<void> clear();
}
```

#### Cache Keys (Type-Safe)

```dart
class CacheKeys {
  static String recentPapers({String? category, int page = 1}) =>
    'recent_papers_${category ?? 'all'}_page_$page';
  
  static String recommendations({int page = 1}) =>
    'recommendations_page_$page';
    
  static String libraryStats() => 'library_stats';
  static String readingHistory() => 'reading_history';
  static String currentUser() => 'current_user';
}
```

#### Cache Invalidation

Real-time cache invalidation via `CacheNotifier`:

```dart
// When something changes, notify listeners
CacheNotifier.instance.notify(CacheKeys.libraryStats());

// Cubits listen and reload
CacheNotifier.instance.stream.listen((key) {
  if (key == CacheKeys.libraryStats()) {
    _reloadLibraryData();
  }
});
```

#### TTL & Freshness

Cache records store:
- `payload` (JSON data)
- `cachedAt` (timestamp)
- `ttlSeconds` (expiration duration)

Freshness check:
```dart
bool isFresh(DateTime now) =>
  now.difference(cachedAt).inSeconds < ttlSeconds;
```

#### Stale-While-Revalidate Pattern

1. User opens app
2. App returns **stale cached data** immediately (fast UI)
3. In background, app fetches fresh data
4. When fresh data arrives, cache updated
5. If UI is still showing old data, next interaction shows fresh data

This provides perceived instant loading while keeping data fresh.

---

**Feature Modules** (Key modules — purpose, important screens, cubits, repos)

- Chatbot
	- Purpose: Conversational research assistant, supports file uploads, streaming responses.
	- Screens: `lib/features/chatbot/presentation/screens/chatbot_screen.dart`.
	- Cubits: `ChatbotCubit` (`lib/features/chatbot/presentation/cubit/chatbot_cubit.dart`), `SessionsCubit` for session list.
	- Repository: `ChatbotRepositoryImpl` (`lib/features/chatbot/data/repositories/chatbot_repository_impl.dart`).
	- Data sources: `ChatbotRemoteDataSourceImpl` supports multipart uploads and SSE streaming.

- Auth
	- Purpose: Sign in/up, social auth, account verification, password reset.
	- Screens: `signin_screen`, `signup_screen`, `verify_account`, `otp_screen`, `reset_password_screen`.
	- Cubit: `AuthCubit`.
	- Data source & repo: `AuthRemoteDataSourceImpl`, `AuthRepositoryImpl`.

- Home / Discovery
	- Purpose: Home feed, search, categories, recommendations.
	- Cubits: `HomeCubit`, `SearchCubit`.

- Discussions (Community)
	- Purpose: Create discussions, comment, vote, and offline sync of created items.
	- Important files: `features/discussions/*` (cubits, models, data sources). Uses SyncManager for queued discussion creation.

- Paper Annotations
	- Purpose: Highlighting and annotating papers, stored locally and synced.
	- Important files: `features/paper_annotations/*`.

For a complete list of features and their folders, see `lib/features/`.

---

**UI / Design System**

- Theme provider: `lib/core/themes/my_theme.dart` defines light/dark themes and design tokens.
- Reusable widgets live under `lib/core/ui/widgets/` (e.g., `MyAppBar`, `MyBody`) and `lib/core/ui`.
- Fonts: `google_fonts` is used; assets/fonts are configured in `pubspec.yaml` and `flutter_intl` is enabled for localization.
- Responsive design: The app uses MaterialApp.router with GoRouter; many screens use responsive layout patterns but there is no single CSS-like responsive system — responsiveness is handled per widget.

---

**AI / Chatbot System**

- Chatbot is implemented as a frontend client to a server-side chatbot API. The app supports:
	- Multipart file uploads (`uploadFile`, `uploadFiles`).
	- Sending messages and receiving either immediate JSON responses or a streaming SSE response parsed by `streamSessionMessages` in `ChatbotRemoteDataSourceImpl`.
	- Streaming implementation parses SSE 'data:' messages and yields decoded strings.

---


 **Navigation & Routing**

#### GoRouter Configuration

Mirath uses **GoRouter** for declarative, type-safe routing with deep linking support.

```dart
// app_router.dart
final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  redirect: (context, state) {
    // Auth guard: redirect unauthenticated users
    final authState = context.read<AuthCubit>().state;
    
    if (authState.status == AuthStatus.unauthenticated &&
        !state.location.startsWith('/signin')) {
      return RouteNames.signin;
    }
    
    return null;  // No redirect
  },
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    // ... more routes
  ],
);
```

#### Route Names (Type-Safe Constants)

```dart
// core/constants/route_names.dart
class RouteNames {
  static const String splash = '/splash';
  static const String signin = '/signin';
 
  // Helper methods
  static String paperDetailsRoute(String paperId) => '/papers/$paperId';
  static String discussionDetailsRoute(String id) => '/discussions/$id';
}
```

#### Navigation Patterns

**Simple Navigation**:
```dart
appRouter.go(RouteNames.home);
```

**Push with Return Value**:
```dart
final result = await appRouter.push(RouteNames.editProfile);
```

**Replace (no back button)**:
```dart
appRouter.replace(RouteNames.home);
```

**Named Route with Parameter**:
```dart
appRouter.push(RouteNames.paperDetailsRoute('paper-123'));
```

#### Deep Linking

The app handles deep links from:
- Email links (shared papers, discussions)
- Web URLs
- Native app links

```dart
// main.dart handles deep link on app start
void _handleDeepLinkIfAny() {
  final uri = Uri.base;
  final path = uri.fragment;  // For web hash routing
  
  if (path.contains('/papers/')) {
    // Navigate to paper after auth resolves
    appRouter.push(target);
  }
}
```

**Supported Deep Links**:

- mirath.app/papers/:paperId
- mirath.app/discussions/:discussionId
- mirath.app/reading-lists/:listId
- mirath.app/users/:userId


---

 **Network & Connectivity**

##### Network Manager

Singleton `NetworkManager` monitors real-time connectivity:

```dart
// Checks actual internet access (not just WiFi connection)
Future<bool> get isConnected async {
  // 1. Check if WiFi/mobile available
  final results = await _connectivity.checkConnectivity();
  if (results.contains(ConnectivityResult.none)) return false;
  
  // 2. Verify real internet by DNS lookup
  for (final domain in ['google.com', 'cloudflare.com', '1.1.1.1']) {
    try {
      final lookup = await InternetAddress.lookup(domain);
      if (lookup.isNotEmpty) return true;
    } catch (_) {}
  }
  
  return false;
}

// Stream real-time connectivity changes
Stream<bool> connectionStream => _connectionController.stream;
```

#### Offline Detection UI

Connected in `main.dart`, displays banner when offline:

```dart
StreamBuilder<bool>(
  stream: NetworkManager.instance.connectionStream,
  builder: (context, snapshot) {
    final isConnected = snapshot.data ?? true;
    
    return Column(
      children: [
        Expanded(child: child),
        if (!isConnected)
          RedBanner(text: 'No internet connection'),
      ],
    );
  },
)
```

#### Graceful Offline Handling

**Strategy**:
1. Check connectivity before making requests
2. If offline, try to return cached data
3. Show "offline" indicator to user
4. Queue changes for sync when online


#### Retry Queue

Failed operations automatically queued for retry:

```dart
// From ChatbotCubit - queue failed message
await retryService.enqueue('send_message', {
  'sessionId': currentSessionId,
  'content': message,
  'files': attachedFiles,
});

// Automatically retries when connectivity restored
```
---

**Security**

- Access tokens are stored in `flutter_secure_storage` via `SecureStorageService`.
- Refresh tokens are expected to be HttpOnly cookies (cookie jar management in Dio client); the interceptor performs POST-based refresh flows while using cookie persistence for non-web platforms. This reduces exposure of refresh tokens in JavaScript contexts.
- Network calls are guarded with `NetworkManager.ensureConnected()` and  many repositories check `networkManager.isConnected`.
- 
---

**Performance Optimizations Observed**

- Caching: TTL-based Hive cache reduces redundant API calls.
- SyncManager + RetryQueue provide offline resilience and controlled retry/backoff.
- Dio `LogInterceptor` can be disabled in release builds for performance.
- Use of `const` widgets and localized incremental fetching (pagination) in repositories contribute to efficient UI updates.

---

**Environment Setup**

Prerequisites
- Flutter (stable) and Dart SDK compatible with `sdk: ^3.10.0` (see `pubspec.yaml`).
- Android SDK / Xcode for device builds.
- For web preview, Firebase CLI is used in CI; to deploy manually configure Firebase with `firebase init` and `firebase deploy`.

Recommended steps (local)

```bash
flutter pub get
# Run on a connected device/emulator
flutter run

# Build
flutter build apk
flutter build appbundle
flutter build web --no-tree-shake-icons
```

Firebase Hosting CI is configured in `.github/workflows` and `firebase.json` for web builds.

---

**Running the Project**

- Install packages:

```bash
flutter pub get
```

- Run (debug) on device/emulator:

```bash
flutter run
```

- Build commands:

```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web --no-tree-shake-icons
```

CI build for web is defined in `.github/workflows` and deploys to Firebase Hosting.

---

**Project Structure (actual snapshot)**

Top-level `lib/` tree (trimmed):

```
lib/
├─ main.dart
├─ app_router.dart
├─ generated/
├─ injection/
│  └─ injection_container.dart
├─ core/
│  ├─ network/ (dio_client, auth interceptor, network manager)
│  ├─ cache/ (hive cache service)
│  ├─ services/ (secure/local/image/audio services)
│  └─ ui/
└─ features/
	 ├─ auth/
	 ├─ chatbot/
	 ├─ home/
	 ├─ discussions/
	 ├─ paper_annotations/
	 ├─ reading_lists/
	 └─ ...
```

You can explore the full structure starting at `lib/` in your editor — the codebase follows feature-first organization.

---

**Important Packages & Why They Exist**

| Package | Purpose |
|---|---|
| bloc / flutter_bloc | State management with Cubits/Blocs for predictable state and testability |
| get_it | Dependency injection / service locator used in `injection_container.dart` |
| dio | Robust HTTP client with interceptors and streaming support |
| cookie_jar / dio_cookie_manager | Persistent cookies support for refresh-token cookie flows |
| hive | Local JSON cache with TTL and repeated lookups (offline support) |
| flutter_secure_storage | Secure storage for access token and sensitive data |
| go_router | Declarative routing with redirects and deep linking |
| google_sign_in | Social login provider (Google Sign-In) |
| recorder / image_picker | Media capture & uploads for chatbot file attachments |

---

**Developer Onboarding (concise)**

1. Prereqs: Install Flutter stable and ensure Dart >=3.10.0.
2. Clone repository and run `flutter pub get`.
3. Open in VS Code / Android Studio — main entrypoint is `lib/main.dart`.
4. DI: Inspect `lib/injection/injection_container.dart` to understand service registration.
5. Router: check `lib/app_router.dart` for routes and redirect logic; inspect `RouteNames` constant helper.
6. Chatbot: See `lib/features/chatbot` for streaming & upload examples.
7. Run app: `flutter run` or `flutter run -d chrome` for web; CI builds web via GitHub Actions.
---

## 🎯 Conclusion

Mirath demonstrates a **sophisticated, production-ready Flutter application** built with enterprise software engineering principles. The architecture prioritizes:

1. **Maintainability**: Clear separation of concerns, modular features
2. **Scalability**: Layered architecture, cache strategies, pagination
3. **Reliability**: Error handling, offline support, retry mechanisms
4. **Security**: Secure storage, JWT authentication, input validation
5. **Performance**: Caching, lazy loading, efficient rebuilds

The codebase is well-positioned for scaling to thousands of active users while maintaining code quality and developer velocity.

