import 'package:uuid/uuid.dart';

class RetryQueueItem {
  final String id;
  final String type;
  final Map<String, dynamic> payload;
  int attempts;
  final DateTime createdAt;

  RetryQueueItem({
    String? id,
    required this.type,
    required this.payload,
    this.attempts = 0,
  }) : id = id ?? const Uuid().v4(),
       createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'payload': payload,
    'attempts': attempts,
    'createdAt': createdAt.toIso8601String(),
  };

  static RetryQueueItem fromJson(Map<String, dynamic> json) => RetryQueueItem(
    id: json['id'] as String,
    type: json['type'] as String,
    payload: Map<String, dynamic>.from(json['payload'] as Map),
    attempts: json['attempts'] as int? ?? 0,
  );
}

abstract class RetryQueue {
  Future<void> add(RetryQueueItem item);
  Future<List<RetryQueueItem>> drain({int limit = 20});
  Future<void> remove(String id);
  Future<void> update(RetryQueueItem item);
}
