import 'package:mirath/features/library/domain/entities/saved_papers.dart';
import 'package:mirath/features/papers/data/models/paper_model.dart';

class SavedPapersModel {
  final int size;
  final List<SavedPaper> data;

  SavedPapersModel({required this.size, required this.data});

  factory SavedPapersModel.fromJson(Map<String, dynamic> json) {
    return SavedPapersModel(
      size: json['size'] ?? 0,
      data:
          (json['data'] as List?)?.map((e) {
            final item = (e as Map<String, dynamic>? ?? {});
            final rawCreatedAt = item['createdAt'];
            final paperJson =
                item['paper'] as Map<String, dynamic>? ?? const {};

            // Ensure papers from saved papers endpoint are marked as saved
            final paper = PaperModel.fromJson(paperJson);
            final savedPaper = PaperModel(
              id: paper.id,
              title: paper.title,
              abstract: paper.abstract,
              citation: paper.citation,
              isSaved: true,
              preprint: paper.preprint,
              authors: paper.authors,
              categories: paper.categories,
              publishedAt: paper.publishedAt,
            );

            return SavedPaper(
              userId: item['userId'] ?? '',
              createdAt: rawCreatedAt is String
                  ? DateTime.tryParse(rawCreatedAt) ?? DateTime.now()
                  : rawCreatedAt is DateTime
                  ? rawCreatedAt
                  : DateTime.now(),
              paperId: item['paperId'] ?? '',
              paper: savedPaper,
            );
          }).toList() ??
          [],
    );
  }
}
