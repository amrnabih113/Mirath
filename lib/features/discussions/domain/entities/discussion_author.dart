class DiscussionAuthor {
  final String id;
  final String username;
  final String fullName;
  final String? photoUrl;
  final String? bio;
  final String role;
  final bool isPremium;
  final bool isFollowing;
  final bool isMe;

  const DiscussionAuthor({
    required this.id,
    required this.username,
    required this.fullName,
    this.photoUrl,
    this.bio,
    required this.role,
    required this.isPremium,
    required this.isFollowing,
    this.isMe = false,
  });

  DiscussionAuthor copyWith({
    String? id,
    String? username,
    String? fullName,
    String? photoUrl,
    String? bio,
    String? role,
    bool? isPremium,
    bool? isFollowing,
    bool? isMe,
  }) {
    return DiscussionAuthor(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      isPremium: isPremium ?? this.isPremium,
      isFollowing: isFollowing ?? this.isFollowing,
      isMe: isMe ?? this.isMe,
    );
  }
}
