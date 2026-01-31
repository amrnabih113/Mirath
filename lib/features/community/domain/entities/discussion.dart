import 'discussion_author.dart';
import 'discussion_paper.dart';
import 'discussion_topic.dart';

class Discussion {
  final String id;
  final String title;
  final String content;
  final int upvoteCount;
  final int downvoteCount;
  final int commentCount;
  final String authorId;
  final List<String> paperIds;
  final List<DiscussionPaper> papers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasVoted;
  final String? userVoteType;
  final List<DiscussionTopic> topics;
  final DiscussionAuthor author;

  const Discussion({
    required this.id,
    required this.title,
    required this.content,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.commentCount,
    required this.authorId,
    required this.paperIds,
    required this.papers,
    required this.createdAt,
    required this.updatedAt,
    required this.hasVoted,
    this.userVoteType,
    required this.topics,
    required this.author,
  });

  int get voteScore => upvoteCount - downvoteCount;

  Discussion copyWith({
    String? id,
    String? title,
    String? content,
    int? upvoteCount,
    int? downvoteCount,
    int? commentCount,
    String? authorId,
    List<String>? paperIds,
    List<DiscussionPaper>? papers,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasVoted,
    String? userVoteType,
    List<DiscussionTopic>? topics,
    DiscussionAuthor? author,
  }) {
    return Discussion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      upvoteCount: upvoteCount ?? this.upvoteCount,
      downvoteCount: downvoteCount ?? this.downvoteCount,
      commentCount: commentCount ?? this.commentCount,
      authorId: authorId ?? this.authorId,
      paperIds: paperIds ?? this.paperIds,
      papers: papers ?? this.papers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasVoted: hasVoted ?? this.hasVoted,
      userVoteType: userVoteType ?? this.userVoteType,
      topics: topics ?? this.topics,
      author: author ?? this.author,
    );
  }
}
