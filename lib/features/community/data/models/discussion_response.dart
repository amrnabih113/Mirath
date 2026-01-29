import 'discussion_model.dart';

class DiscussionResponse {
  final String message;
  final DiscussionModel data;

  const DiscussionResponse({
    required this.message,
    required this.data,
  });

  factory DiscussionResponse.fromJson(Map<String, dynamic> json) {
    return DiscussionResponse(
      message: json['message'] ?? '',
      data: DiscussionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
