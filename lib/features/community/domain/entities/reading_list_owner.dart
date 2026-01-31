class ReadingListOwner {
  final String id;
  final String username;
  final String fullName;

  const ReadingListOwner({
    required this.id,
    required this.username,
    required this.fullName,
  });

  ReadingListOwner copyWith({String? id, String? username, String? fullName}) {
    return ReadingListOwner(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
    );
  }
}
