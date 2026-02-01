import '../../domain/entities/discussion_author.dart';

class DiscussionAuthorModel extends DiscussionAuthor {
  const DiscussionAuthorModel({
    required super.id,
    required super.username,
    required super.fullName,
    super.photoUrl,
    super.bio,
    required super.role,
    required super.isPremium,
  });

  factory DiscussionAuthorModel.fromJson(Map<String, dynamic> json) {
    return DiscussionAuthorModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      role: json['role'] ?? 'USER',
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'bio': bio,
      'role': role,
      'isPremium': isPremium,
    };
  }
}
