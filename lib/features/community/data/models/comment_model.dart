import '../../domain/entities/comment.dart';
import 'discussion_author_model.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.content,
    required super.upvoteCount,
    required super.downvoteCount,
    required super.authorId,
    required super.discussionId,
    super.parentId,
    required super.createdAt,
    required super.updatedAt,
    required super.hasVoted,
    super.userVoteType,
    required super.author,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      upvoteCount: json['upvoteCount'] ?? 0,
      downvoteCount: json['downvoteCount'] ?? 0,
      authorId: json['authorId'] ?? '',
      discussionId: json['discussionId'] ?? '',
      parentId: json['parentId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      hasVoted: json['hasVoted'] ?? false,
      userVoteType: json['userVoteType'],
      author: DiscussionAuthorModel.fromJson(
        json['author'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'upvoteCount': upvoteCount,
      'downvoteCount': downvoteCount,
      'authorId': authorId,
      'discussionId': discussionId,
      'parentId': parentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hasVoted': hasVoted,
      'userVoteType': userVoteType,
      'author': (author as DiscussionAuthorModel).toJson(),
    };
  }
}
