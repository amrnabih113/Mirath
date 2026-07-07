import 'package:mirath/features/chatbot/domain/entities/feedback.dart';


class FeedbackModel extends Feedback {
  FeedbackModel({
    required super.messageId,
    required super.type,
    required super.active,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      messageId: json['messageId'] as String,
      type: json['type'] as String,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'type': type,
      'active': active,
    };
  }
}
