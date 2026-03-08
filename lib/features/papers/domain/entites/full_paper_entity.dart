import 'package:equatable/equatable.dart';

class FullPaperEntity extends Equatable {
  final String id;
  final String citation;
  final String title;
  final String abstract;
  final List<String> authors;
  final List<String> categories;
  final DateTime publishedAt;
  final List<String> content; // raw HTML chunks
  final DateTime createdAt;
  final DateTime updatedAt;

  const FullPaperEntity({
    required this.id,
    required this.citation,
    required this.title,
    required this.abstract,
    required this.authors,
    required this.categories,
    required this.publishedAt,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    citation,
    title,
    abstract,
    authors,
    categories,
    publishedAt,
    content,
    createdAt,
    updatedAt,
  ];
}
