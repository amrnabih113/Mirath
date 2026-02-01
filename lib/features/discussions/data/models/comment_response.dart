import 'comment_model.dart';

class CommentResponse {
  final String message;
  final CommentModel data;

  const CommentResponse({required this.message, required this.data});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      message: json['message'] ?? '',
      data: CommentModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
