import 'discussion_author.dart';

class Comment {
  final String id;
  final String content;
  final int upvoteCount;
  final int downvoteCount;
  final String authorId;
  final String discussionId;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasVoted;
  final String? userVoteType;
  final DiscussionAuthor author;
  final bool isPending;

  const Comment({
    required this.id,
    required this.content,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.authorId,
    required this.discussionId,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.hasVoted,
    this.userVoteType,
    required this.author,
    this.isPending = false,
  });

  int get voteScore => upvoteCount - downvoteCount;

  Comment copyWith({
    String? id,
    String? content,
    int? upvoteCount,
    int? downvoteCount,
    String? authorId,
    String? discussionId,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasVoted,
    String? userVoteType,
    DiscussionAuthor? author,
    bool? isPending,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      upvoteCount: upvoteCount ?? this.upvoteCount,
      downvoteCount: downvoteCount ?? this.downvoteCount,
      authorId: authorId ?? this.authorId,
      discussionId: discussionId ?? this.discussionId,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasVoted: hasVoted ?? this.hasVoted,
      userVoteType: userVoteType ?? this.userVoteType,
      author: author ?? this.author,
      isPending: isPending ?? this.isPending,
    );
  }
}
