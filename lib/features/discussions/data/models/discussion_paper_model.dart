import '../../domain/entities/discussion_paper.dart';

class DiscussionPaperModel extends DiscussionPaper {
  const DiscussionPaperModel({
    required super.id,
    required super.authors,
    required super.title,
    required super.abstract,
  });

  factory DiscussionPaperModel.fromJson(Map<String, dynamic> json) {
    return DiscussionPaperModel(
      id: json['id'] ?? '',
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'authors': authors, 'title': title, 'abstract': abstract};
  }
}
