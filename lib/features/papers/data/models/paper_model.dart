import 'package:mirath/features/home/domain/entities/paper_entity.dart';

class PaperModel extends PaperEntity {
  const PaperModel({
    required super.id,
    required super.title,
    required super.abstract,
    required super.citation,
    required super.isSaved,
    required super.preprint,
    required super.authors,
    required super.categories,
    required super.publishedAt,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    final rawPublishedAt = json['publishedAt'];

    return PaperModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
      citation: json['citation'] ?? '',
      isSaved: json['isSaved'] ?? false,
      preprint: (json['preprint'] ?? '').toString(),
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      publishedAt: rawPublishedAt is String
          ? DateTime.tryParse(rawPublishedAt) ?? DateTime.now()
          : rawPublishedAt is DateTime
          ? rawPublishedAt
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'abstract': abstract,
      'citation': citation,
      'authors': authors,
      'categories': categories,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  factory PaperModel.fromEntity(PaperEntity paper) {
    return PaperModel(
      id: paper.id,
      title: paper.title,
      abstract: paper.abstract,
      citation: paper.citation,
      isSaved: paper.isSaved,
      preprint: paper.preprint,
      authors: paper.authors,
      categories: paper.categories,
      publishedAt: paper.publishedAt,
    );
  }

  PaperEntity toEntity() {
    return PaperEntity(
      id: id,
      title: title,
      abstract: abstract,
      citation: citation,
      authors: authors,
      preprint: preprint,
      isSaved: isSaved,
      categories: categories,
      publishedAt: publishedAt,
    );
  }
}
