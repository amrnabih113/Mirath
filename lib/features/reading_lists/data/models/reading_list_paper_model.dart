import '../../domain/entities/reading_list_paper.dart';

class ReadingListPaperModel extends ReadingListPaper {
  const ReadingListPaperModel({
    required super.readingListId,
    required super.paperId,
    super.paper,
  });

  factory ReadingListPaperModel.fromJson(Map<String, dynamic> json) {
    return ReadingListPaperModel(
      readingListId: json['readingListId'] ?? '',
      paperId: json['paperId'] ?? '',
      paper: json['paper'] != null
          ? PaperModel.fromJson(json['paper'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'readingListId': readingListId,
      'paperId': paperId,
      if (paper != null) 'paper': (paper as PaperModel).toJson(),
    };
  }
}

class PaperModel extends Paper {
  const PaperModel({
    required super.id,
    required super.title,
    required super.abstract,
    required super.citation,
    required super.authors,
    required super.categories,
    required super.publishedAt,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
      citation: json['citation'] ?? '',
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
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
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

  factory PaperModel.fromEntity(Paper paper) {
    return PaperModel(
      id: paper.id,
      title: paper.title,
      abstract: paper.abstract,
      citation: paper.citation,
      authors: paper.authors,
      categories: paper.categories,
      publishedAt: paper.publishedAt,
    );
  }

  Paper toEntity() {
    return Paper(
      id: id,
      title: title,
      abstract: abstract,
      citation: citation,
      authors: authors,
      categories: categories,
      publishedAt: publishedAt,
    );
  }
}
