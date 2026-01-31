import 'reading_list_model.dart';

class ReadingListsResponse {
  final String message;
  final int size;
  final List<ReadingListModel> data;

  const ReadingListsResponse({
    required this.message,
    required this.size,
    required this.data,
  });

  factory ReadingListsResponse.fromJson(Map<String, dynamic> json) {
    return ReadingListsResponse(
      message: json['message'] ?? '',
      size: json['size'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ReadingListModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'size': size,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
