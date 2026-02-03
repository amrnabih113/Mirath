import 'package:equatable/equatable.dart';

class PaperEntity extends Equatable {
  final String id;
  final String title;
  final String preprint;
  final String abstract;
  final String publishedAt;
  final List<String> authors;
  final List<String> categories;
  final bool isSaved;

  const PaperEntity({
    required this.id,
    required this.title,
    required this.abstract,
    required this.publishedAt,
    required this.authors,
    required this.categories,
    required this.isSaved,
    required this.preprint,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    preprint,
    abstract,
    publishedAt,
    authors,
    categories,
    isSaved,
  ];

  PaperEntity copyWith({
    String? id,
    String? title,
    String? preprint,
    String? abstract,
    String? publishedAt,
    List<String>? authors,
    List<String>? categories,
    bool? isSaved,
  }) {
    return PaperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      preprint: preprint ?? this.preprint,
      abstract: abstract ?? this.abstract,
      publishedAt: publishedAt ?? this.publishedAt,
      authors: authors ?? this.authors,
      categories: categories ?? this.categories,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
