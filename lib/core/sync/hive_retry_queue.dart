import 'package:mirath/core/cache/hive_cache_service.dart';
import 'retry_queue.dart';

/// Hive-backed implementation of [RetryQueue]. Stores the queue as a JSON list
/// under key `retry:queue` using the existing HiveCacheService.
class HiveRetryQueue implements RetryQueue {
  static const _queueKey = 'retry:queue';

  final HiveCacheService cacheService;

  HiveRetryQueue({required this.cacheService});

  @override
  Future<void> add(RetryQueueItem item) async {
    final current =
        await cacheService.getJsonList(_queueKey, allowStale: true) ?? [];
    final list = List<Map<String, dynamic>>.from(current);
    list.add(item.toJson());
    await cacheService.putJsonList(_queueKey, list);
  }

  @override
  Future<List<RetryQueueItem>> drain({int limit = 20}) async {
    final current =
        await cacheService.getJsonList(_queueKey, allowStale: true) ?? [];
    final items = current.map((e) => RetryQueueItem.fromJson(e)).toList();
    if (items.length <= limit) return items;
    return items.sublist(0, limit);
  }

  @override
  Future<void> remove(String id) async {
    final current =
        await cacheService.getJsonList(_queueKey, allowStale: true) ?? [];
    final filtered = current.where((e) => (e['id'] as String) != id).toList();
    await cacheService.putJsonList(
      _queueKey,
      filtered.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }

  @override
  Future<void> update(RetryQueueItem item) async {
    final current =
        await cacheService.getJsonList(_queueKey, allowStale: true) ?? [];
    final list = List<Map<String, dynamic>>.from(current);
    final idx = list.indexWhere((e) => (e['id'] as String) == item.id);
    if (idx == -1) {
      // Item not found; append as fallback
      list.add(item.toJson());
    } else {
      list[idx] = item.toJson();
    }
    await cacheService.putJsonList(_queueKey, list);
  }
}
