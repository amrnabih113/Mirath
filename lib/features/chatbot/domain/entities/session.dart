class Session {
  final String id;
  final String? title;
  final String? userId;
  final bool isTemporary;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;

  const Session({
    required this.id,
    this.title,
    this.userId,
    this.isTemporary = false,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
  });

  Session copyWith({
    String? id,
    String? title,
    String? userId,
    bool? isTemporary,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      isTemporary: isTemporary ?? this.isTemporary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
