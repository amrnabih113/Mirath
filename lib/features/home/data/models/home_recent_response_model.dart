//Example of recent Endpoint response
// ```json
// {
//   "message": "Recent papers fetched successfully",
//   "size": 2,
//   "data": [
//     {
//       "id": "3f1e8d6a-9a45-4f2a-8a8a-1b9c9a8e1111",
//       "title": "Artificial Intelligence in Healthcare",
//       "abstract": "This paper explores the impact of AI in modern healthcare systems.",
//       "publishedAt": "2026-01-10T12:00:00.000Z",
//       "authors": [
//         "John Doe",
//         "Jane Smith"
//       ],
//       "categories": [
//         "AI",
//         "Healthcare"
//       ],
//       "isSaved": true
//     },
//     {
//       "id": "8b2c4a1d-7d21-44f6-9c4a-2e9a0c222222",
//       "title": "Deep Learning Advances",
//       "abstract": "A survey of recent advances in deep learning.",
//       "publishedAt": "2026-01-08T09:30:00.000Z",
//       "authors": [
//         "Alan Turing"
//       ],
//       "categories": [
//         "AI"
//       ],
//       "isSaved": false
//     }
//   ]
// }
// ```
import 'package:mirath/features/home/data/models/home_recent_paper_model.dart';

class HomeRecentResponseModel {
  final String message;
  final int size;
  final List<HomeRecentPaperModel> data;

  const HomeRecentResponseModel({
    required this.message,
    required this.size,
    required this.data,
  });

  factory HomeRecentResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeRecentResponseModel(
      message: json['message'] ?? '',
      size: json['size'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => HomeRecentPaperModel.fromJson(e))
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
