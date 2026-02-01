import '../../domain/entities/discussion_topic.dart';

class DiscussionTopicModel extends DiscussionTopic {
  const DiscussionTopicModel({
    required super.id,
    required super.name,
    required super.custom,
  });

  factory DiscussionTopicModel.fromJson(Map<String, dynamic> json) {
    return DiscussionTopicModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      custom: json['custom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'custom': custom};
  }
}
