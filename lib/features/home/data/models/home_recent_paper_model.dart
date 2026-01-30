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

import '../../domain/entities/paper_entity.dart';

class HomeRecentPaperModel {
  final String id;
  final String title;
  final String preprint;
  final String abstract;
  final String publishedAt;
  final List<String> authors;
  final List<String> categories;
  final bool isSaved;

  const HomeRecentPaperModel({
    required this.id,
    required this.title,
    required this.abstract,
    required this.publishedAt,
    required this.authors,
    required this.categories,
    required this.isSaved,
    required this.preprint,
  });

  factory HomeRecentPaperModel.fromJson(Map<String, dynamic> json) {
    return HomeRecentPaperModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
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
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'preprint': preprint,
      'abstract': abstract,
      'publishedAt': publishedAt,
      'authors': authors,
      'categories': categories,
      'isSaved': isSaved,
    };
  }

  factory HomeRecentPaperModel.empty() => HomeRecentPaperModel(
    id: '',
    title: '',
    abstract: '',
    publishedAt: '',
    authors: [],
    categories: [],
    isSaved: false,
    preprint: '',
  );
}

extension HomeRecentPaperModelX on HomeRecentPaperModel {
  PaperEntity toPaperEntity() {
    return PaperEntity(
      id: id,
      title: title,
      abstract: abstract,
      publishedAt: publishedAt,
      authors: authors,
      categories: categories,
      isSaved: isSaved,
      preprint: '',
    );
  }
}
