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
  final bool isPending;

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
    this.isPending = false,
  });

  Comment copyWith({
    String? id,
    String? content,
    int? voteScore,
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
      voteScore: voteScore ?? this.voteScore,
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
