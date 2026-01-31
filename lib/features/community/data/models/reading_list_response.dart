import 'reading_list_model.dart';

class ReadingListResponse {
  final String message;
  final ReadingListModel data;

  const ReadingListResponse({required this.message, required this.data});

  factory ReadingListResponse.fromJson(Map<String, dynamic> json) {
    return ReadingListResponse(
      message: json['message'] ?? '',
      data: ReadingListModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.toJson()};
  }
}
