import 'package:intl/intl.dart';
import 'package:mirath/features/settings/domain/entities/all_active_session_entity.dart';

class AllActiveSessionModel extends AllActiveSessionEntity {
  final int size;

  AllActiveSessionModel({
    required this.size,

    required super.sessionId,
    required super.createdAt,
    required super.expiresAt,
    required super.isCurrent,
  });

  factory AllActiveSessionModel.fromJson(Map<String, dynamic> json) {
    return AllActiveSessionModel(
      size: json['size'] ?? 0,

      sessionId: json['sessionId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      
      expiresAt: DateTime.parse(json['expiresAt']),
      isCurrent: json['isCurrent'] ?? false,
    );
  }
  @override
  String toString() {
    return 'sessionId: $sessionId, isCurrent: $isCurrent,createdAt: $createdAt, expiresAt: $expiresAt, size: $size';
  }
}
