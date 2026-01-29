import '../../domain/entities/discussion.dart';
import 'discussion_author_model.dart';
import 'discussion_topic_model.dart';

class DiscussionModel extends Discussion {
  const DiscussionModel({
    required super.id,
    required super.title,
    required super.content,
    required super.voteScore,
    required super.commentCount,
    required super.authorId,
    required super.paperIds,
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
      voteScore: json['voteScore'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      authorId: json['authorId'] ?? '',
      paperIds: (json['paperIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
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
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => DiscussionTopicModel.fromJson(e as Map<String, dynamic>))
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
      'voteScore': voteScore,
      'commentCount': commentCount,
      'authorId': authorId,
      'paperIds': paperIds,
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
