import 'package:flutter_test/flutter_test.dart';
import 'package:mirath/core/sync/retry_queue.dart';
import 'package:mirath/core/sync/sync_manager.dart';

class FakeRetryQueue implements RetryQueue {
  final List<RetryQueueItem> _items = [];

  @override
  Future<void> add(RetryQueueItem item) async {
    _items.add(item);
  }

  @override
  Future<List<RetryQueueItem>> drain({int limit = 20}) async {
    final items = List<RetryQueueItem>.from(_items.take(limit));
    return items;
  }

  @override
  Future<void> remove(String id) async {
    _items.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> update(RetryQueueItem item) async {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx == -1) {
      _items.add(item);
    } else {
      _items[idx] = item;
    }
  }

  int count() => _items.length;
}

void main() {
  test('RetryQueueItem serializes and deserializes', () {
    final item = RetryQueueItem(type: 'test', payload: {'a': 1});
    final json = item.toJson();
    final item2 = RetryQueueItem.fromJson(Map<String, dynamic>.from(json));
    expect(item2.type, equals('test'));
    expect(item2.payload['a'], equals(1));
    expect(item2.attempts, equals(0));
  });

  test('SyncManager processes items and removes on success', () async {
    final queue = FakeRetryQueue();
    final manager = SyncManager(retryQueue: queue);

    var processed = 0;
    manager.registerHandler('ok', (payload) async {
      processed++;
    });

    await queue.add(RetryQueueItem(type: 'ok', payload: {'x': 1}));
    expect(queue.count(), 1);

    await manager.processPending();
    expect(processed, 1);
    expect(queue.count(), 0);
  });

  test('SyncManager retries on failure and updates attempts', () async {
    final queue = FakeRetryQueue();
    final manager = SyncManager(retryQueue: queue);

    var tries = 0;
    manager.registerHandler('fail', (payload) async {
      tries++;
      throw Exception('boom');
    });

    final item = RetryQueueItem(type: 'fail', payload: {});
    await queue.add(item);

    await manager.processPending();

    // Should have attempted and left the item in queue with attempts incremented
    final remaining = await queue.drain();
    expect(remaining.isNotEmpty, true);
    expect(remaining.first.attempts, greaterThanOrEqualTo(1));
    expect(tries, greaterThan(0));
  });
}
