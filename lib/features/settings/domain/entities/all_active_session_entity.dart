class AllActiveSessionEntity {
  final String sessionId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isCurrent;

  AllActiveSessionEntity({
    required this.sessionId,
    required this.createdAt,
    required this.expiresAt,
    required this.isCurrent,
  });
}
