import '../../domain/entities/discussion.dart';
import 'discussion_author_model.dart';
import 'discussion_paper_model.dart';
import 'discussion_topic_model.dart';

class DiscussionModel extends Discussion {
  const DiscussionModel({
    required super.id,
    required super.title,
    required super.content,
    required super.upvoteCount,
    required super.downvoteCount,
    required super.commentCount,
    required super.authorId,
    required super.paperIds,
    required super.papers,
    required super.createdAt,
    required super.updatedAt,
    required super.hasVoted,
    super.userVoteType,
    required super.topics,
    required super.author,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      upvoteCount: json['upvoteCount'] ?? 0,
      downvoteCount: json['downvoteCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      authorId: json['authorId'] ?? '',
      paperIds:
          (json['paperIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      papers:
          (json['papers'] as List<dynamic>?)
              ?.map(
                (e) => DiscussionPaperModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      hasVoted: json['hasVoted'] ?? false,
      userVoteType: json['userVoteType'],
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map(
                (e) => DiscussionTopicModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      author: DiscussionAuthorModel.fromJson(
        json['author'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'upvoteCount': upvoteCount,
      'downvoteCount': downvoteCount,
      'commentCount': commentCount,
      'authorId': authorId,
      'paperIds': paperIds,
      'papers': papers
          .map((p) => (p as DiscussionPaperModel).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hasVoted': hasVoted,
      'userVoteType': userVoteType,
      'topics': topics
          .map((t) => (t as DiscussionTopicModel).toJson())
          .toList(),
      'author': (author as DiscussionAuthorModel).toJson(),
    };
  }
}
