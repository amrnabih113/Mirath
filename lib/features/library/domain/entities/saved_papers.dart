class SavedPapers {
  final String userId, paperId, id, title, abstract;
  final DateTime createdAt;
  final List<String> authors;
  final int size;

  SavedPapers({
    required this.userId,
    required this.paperId,
    required this.id,
    required this.title,
    required this.abstract,
    required this.createdAt,
    required this.authors,
    required this.size,
  });
}
