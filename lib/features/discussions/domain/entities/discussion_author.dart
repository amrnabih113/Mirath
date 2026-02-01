class DiscussionAuthor {
  final String id;
  final String username;
  final String fullName;
  final String? photoUrl;
  final String? bio;
  final String role;
  final bool isPremium;

  const DiscussionAuthor({
    required this.id,
    required this.username,
    required this.fullName,
    this.photoUrl,
    this.bio,
    required this.role,
    required this.isPremium,
  });
}
