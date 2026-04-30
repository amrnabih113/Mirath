import 'package:mirath/features/library/domain/entities/saved_papers.dart';
import 'package:mirath/features/papers/data/models/full_paper_model.dart';

class SavedPapersModel extends SavedPapers {
  SavedPapersModel({
    required super.authors,
    required super.userId,
    required super.paperId,
    required super.paper,
    required super.createdAt,
    required super.size,
  });

  factory SavedPapersModel.fromJson(Map<String, dynamic> json) {
    return SavedPapersModel(
      userId: json['userId'] ?? '',
      paperId: json['paperId'] ?? '',
      paper: (json['paper'] as List<dynamic>?)
              ?.map((item) => FullPaperModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      authors: List<String>.from(json['authors'] ?? []),
      size: json['size'] ?? 0,
    );
  }
}
