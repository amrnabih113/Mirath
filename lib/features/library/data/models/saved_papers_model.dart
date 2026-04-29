import 'package:mirath/features/library/domain/entities/saved_papers.dart';

class SavedPapersModel extends SavedPapers {
  SavedPapersModel({
    required super.userId,
    required super.paperId,
    required super.id,
    required super.title,
    required super.abstract,
    required super.createdAt,
    required super.authors,
    required super.size,
  });

  factory SavedPapersModel.fromJson(Map<String, dynamic> json) {
    return SavedPapersModel(
      userId: json['data'][0]['userId'] ?? '',
      paperId: json['data'][0]['paperId'] ?? '',
      id: json['data'][0]['paper']['id'] ?? '',
      title: json['data'][0]['paper']['title'] ?? '',
      abstract: json['data'][0]['paper']['abstract'] ?? '',
      createdAt: json['data'][0]['createdAt'] != null
          ? DateTime.parse(json['data'][0]['createdAt'])
          : DateTime.now(),
      authors: json['data'][0]['paper']['authors'] ?? [],
      size: json['size'] ?? 0,
    );
  }
}
