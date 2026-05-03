import '../../domain/entities/paper_entity.dart';

class SearchPaperModel {
  final String id;
  final String title;
  final String preprint;
  final String abstract;
  final DateTime publishedAt;
  final List<String> authors;
  final List<String> categories;
  final bool isSaved;
  final String citation;

  const SearchPaperModel({
    required this.id,
    required this.title,
    required this.preprint,
    required this.abstract,
    required this.publishedAt,
    required this.authors,
    required this.categories,
    required this.isSaved,
    required this.citation,
  });

  factory SearchPaperModel.fromJson(Map<String, dynamic> json) {
    return SearchPaperModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
      publishedAt: json['publishedAt'] ?? DateTime.now(),
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isSaved: json['isSaved'] ?? false,
      preprint: json['preprint'] ?? '',
      citation: json['citation'] ?? '',
    );
  }

  PaperEntity toEntity() {
    return PaperEntity(
      id: id,
      title: title,
      preprint: preprint,
      abstract: abstract,
      publishedAt: publishedAt,
      citation: citation,
      authors: authors,
      categories: categories,
      isSaved: isSaved,
    );
  }
}
