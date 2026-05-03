class ReadingListOwner {
  final String id;
  final String username;
  final String fullName;
  final String? photoUrl;

  const ReadingListOwner({
    required this.id,
    required this.username,
    required this.fullName,
    this.photoUrl,
  });

  ReadingListOwner copyWith({
    String? id,
    String? username,
    String? fullName,
    String? photoUrl,
  }) {
    return ReadingListOwner(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
