import 'retry_queue.dart';

class RetryService {
  final RetryQueue retryQueue;

  RetryService(this.retryQueue);

  Future<void> enqueue(String type, Map<String, dynamic> payload) async {
    final item = RetryQueueItem(type: type, payload: payload);
    await retryQueue.add(item);
  }
}
