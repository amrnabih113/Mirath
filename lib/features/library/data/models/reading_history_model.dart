import 'package:mirath/features/library/domain/entities/reading_history.dart';

class ReadingHistoryModel extends ReadingHistory {
  ReadingHistoryModel({
    required super.size,
    required super.paperId,
    required super.id,
    required super.title,
    required super.authors,
    required super.abstract,
    required super.viewdAt,
    required super.publishedAt,
    required super.categories,
  });

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryModel(
      size: json['size'] ?? 0,
      paperId: json['data'][0]['paperId'] ?? '',
      id: json['data'][0]['paper']['id'] ?? '',
      title: json['data'][0]['paper']['title'] ?? '',
      authors: json['data'][0]['paper']['authors'] ?? [],
      abstract: json['data'][0]['paper']['abstract'] ?? '',
      viewdAt: json['data'][0]['viewdAt'] != null
          ? DateTime.parse(json['data'][0]['viewdAt'])
          : DateTime.now(),
      publishedAt: json['data'][0]['paper']['publishedAt'] != null
          ? DateTime.parse(json['data'][0]['paper']['publishedAt'])
          : DateTime.now(),
      categories: json['data'][0]['paper']['categories'] ?? [],
    );
  }
}
