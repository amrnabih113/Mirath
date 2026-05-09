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
    // Parse publishedAt safely - it comes as ISO 8601 string from API
    DateTime parsedDate = DateTime.now();
    try {
      if (json['publishedAt'] != null) {
        final dateStr = json['publishedAt'];
        if (dateStr is String) {
          parsedDate = DateTime.parse(dateStr);
        } else if (dateStr is DateTime) {
          parsedDate = dateStr;
        }
      }
    } catch (e) {
      print('Error parsing publishedAt: $e');
    }

    return SearchPaperModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
      publishedAt: parsedDate,
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
