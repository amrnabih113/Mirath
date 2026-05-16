import '../../../../core/utils/my_logger.dart';
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
    required super.isFollowing,
    super.isMe,
  });

  factory DiscussionAuthorModel.fromJson(Map<String, dynamic> json) {
    final isFollowing = json['isFollowing'] ?? json['isFollowed'] ?? false;
    MyLogger.debug(
      "DiscussionAuthorModel.fromJson - username: ${json['username']}, "
      "json['isFollowing']: ${json['isFollowing']}, "
      "json['isFollowed']: ${json['isFollowed']}, "
      "parsed isFollowing: $isFollowing",
    );
    return DiscussionAuthorModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      role: json['role'] ?? 'USER',
      isPremium: json['isPremium'] ?? false,
      isFollowing: isFollowing,
      isMe: json['isMe'] ?? false,
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
      'isFollowing': isFollowing,
      'isMe': isMe,
    };
  }
}
