import 'discussion_author.dart';

class Comment {
  final String id;
  final String content;
  final int voteScore;
  final String authorId;
  final String discussionId;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasVoted;
  final String? userVoteType;
  final DiscussionAuthor author;

  const Comment({
    required this.id,
    required this.content,
    required this.voteScore,
    required this.authorId,
    required this.discussionId,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.hasVoted,
    this.userVoteType,
    required this.author,
  });
}
