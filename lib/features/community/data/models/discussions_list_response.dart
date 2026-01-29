import 'discussion_model.dart';

class DiscussionsListResponse {
  final String message;
  final int size;
  final List<DiscussionModel> data;

  const DiscussionsListResponse({
    required this.message,
    required this.size,
    required this.data,
  });

  factory DiscussionsListResponse.fromJson(Map<String, dynamic> json) {
    return DiscussionsListResponse(
      message: json['message'] ?? '',
      size: json['size'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => DiscussionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
