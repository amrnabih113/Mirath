import 'dart:async';
import 'dart:math';

import 'retry_queue.dart';
import '../network/network_manager.dart';

/// SyncManager processes pending operations from the RetryQueue and executes
/// them with controlled concurrency and exponential backoff. Integrate with
/// NetworkManager to trigger on connectivity restore.
class SyncManager {
  final RetryQueue retryQueue;
  StreamSubscription<bool>? _connSub;
  bool _running = false;

  final Map<String, Future<void> Function(Map<String, dynamic>)> _handlers = {};

  SyncManager({required this.retryQueue});

  /// Start listening to connectivity changes and process pending items when
  /// connectivity is restored.
  void start() {
    _connSub ??= NetworkManager.instance.connectionStream.listen((connected) {
      if (connected) {
        // small delay to allow network stabilization
        Future.delayed(
          const Duration(milliseconds: 500),
          () => processPending(),
        );
      }
    });
  }

  void stop() {
    _connSub?.cancel();
    _connSub = null;
  }

  Future<void> processPending() async {
    if (_running) return;
    _running = true;
    try {
      const int maxAttempts = 5;
      while (true) {
        final items = await retryQueue.drain(limit: 10);
        if (items.isEmpty) break;
        for (final item in items) {
          final handler = _handlers[item.type];
          if (handler == null) {
            // No handler registered; remove to avoid blocking queue
            await retryQueue.remove(item.id);
            continue;
          }

          try {
            await handler(item.payload);
            await retryQueue.remove(item.id);
          } catch (_) {
            // Increment attempts and update the item in the persistent queue
            item.attempts += 1;
            if (item.attempts >= maxAttempts) {
              // give up and remove
              await retryQueue.remove(item.id);
            } else {
              await retryQueue.update(item);
            }
            // Exponential backoff with jitter
            final baseMs = 500;
            final exp = pow(2, item.attempts);
            final delayMs = (baseMs * exp).toInt().clamp(0, 30000);
            final jitter = Random().nextInt(2000);
            await Future.delayed(Duration(milliseconds: delayMs + jitter));
          }
        }
      }
    } finally {
      _running = false;
    }
  }

  /// Register a handler for a queued item type.
  void registerHandler(
    String type,
    Future<void> Function(Map<String, dynamic>) handler,
  ) {
    _handlers[type] = handler;
  }
}
