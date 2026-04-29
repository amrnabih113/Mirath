class ReadingHistory {
  final int size;
  final String paperId, id, title, abstract;
  final DateTime viewdAt, publishedAt;
  final List<String> authors, categories;

  ReadingHistory({
    required this.size,
    required this.paperId,
    required this.id,
    required this.title,
    required this.authors,
    required this.abstract,
    required this.viewdAt,
    required this.publishedAt,
    required this.categories,
  });
}
