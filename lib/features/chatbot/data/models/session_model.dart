import '../../domain/entities/session.dart';

class SessionModel {
  final String id;
  final String? title;
  final String? userId;
  final bool isTemporary;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;

  SessionModel({
    required this.id,
    this.title,
    this.userId,
    this.isTemporary = false,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SessionModel(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString(),
      userId: data['userId']?.toString(),
      isTemporary: data['isTemporary'] == true,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'].toString())
          : null,
      expiresAt: data['expiresAt'] != null
          ? DateTime.tryParse(data['expiresAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'userId': userId,
    'isTemporary': isTemporary,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
  };

  Session toEntity() {
    return Session(
      id: id,
      title: title,
      userId: userId,
      isTemporary: isTemporary,
      createdAt: createdAt,
      updatedAt: updatedAt,
      expiresAt: expiresAt,
    );
  }

  factory SessionModel.fromEntity(Session s) {
    return SessionModel(
      id: s.id,
      title: s.title,
      userId: s.userId,
      isTemporary: s.isTemporary,
      createdAt: s.createdAt,
      updatedAt: s.updatedAt,
      expiresAt: s.expiresAt,
    );
  }
}
