class Follows {
  final String id;
  final String username;
  final String fullname;
  final String photoUrl;
  final String bio;
  final String role;
  final String status;
  final bool isPremium;
  final bool isFollowing;

  Follows({
    required this.id,
    required this.username,
    required this.fullname,
    required this.photoUrl,
    required this.bio,
    required this.role,
    required this.status,
    required this.isPremium,
    required this.isFollowing,
  });
}