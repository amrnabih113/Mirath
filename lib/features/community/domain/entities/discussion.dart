import 'discussion_author.dart';
import 'discussion_topic.dart';

class Discussion {
  final String id;
  final String title;
  final String content;
  final int voteScore;
  final int commentCount;
  final String authorId;
  final List<String> paperIds;
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
    required this.voteScore,
    required this.commentCount,
    required this.authorId,
    required this.paperIds,
    required this.createdAt,
    required this.updatedAt,
    required this.hasVoted,
    this.userVoteType,
    required this.topics,
    required this.author,
  });

  Discussion copyWith({
    String? id,
    String? title,
    String? content,
    int? voteScore,
    int? commentCount,
    String? authorId,
    List<String>? paperIds,
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
      voteScore: voteScore ?? this.voteScore,
      commentCount: commentCount ?? this.commentCount,
      authorId: authorId ?? this.authorId,
      paperIds: paperIds ?? this.paperIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasVoted: hasVoted ?? this.hasVoted,
      userVoteType: userVoteType ?? this.userVoteType,
      topics: topics ?? this.topics,
      author: author ?? this.author,
    );
  }
}
