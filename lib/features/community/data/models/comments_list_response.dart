import 'comment_model.dart';

class CommentsListResponse {
  final String message;
  final int size;
  final List<CommentModel> data;

  const CommentsListResponse({
    required this.message,
    required this.size,
    required this.data,
  });

  factory CommentsListResponse.fromJson(Map<String, dynamic> json) {
    return CommentsListResponse(
      message: json['message'] ?? '',
      size: json['size'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
