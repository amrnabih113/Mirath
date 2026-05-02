class ReadingListPaper {
  final String readingListId;
  final String paperId;
  final Paper? paper;

  const ReadingListPaper({
    required this.readingListId,
    required this.paperId,
    this.paper,
  });

  ReadingListPaper copyWith({
    String? readingListId,
    String? paperId,
    Paper? paper,
  }) {
    return ReadingListPaper(
      readingListId: readingListId ?? this.readingListId,
      paperId: paperId ?? this.paperId,
      paper: paper ?? this.paper,
    );
  }
}

class Paper {
  final String id;
  final String title;
  final String abstract;
  final String citation;
  final List<String> authors;
  final List<String> categories;
  final DateTime publishedAt;

  const Paper({
    required this.id,
    required this.title,
    required this.abstract,
    required this.citation,
    required this.authors,
    required this.categories,
    required this.publishedAt,
  });

  Paper copyWith({
    String? id,
    String? title,
    String? abstract,
    String? citation,
    List<String>? authors,
    List<String>? categories,
    DateTime? publishedAt,
  }) {
    return Paper(
      id: id ?? this.id,
      title: title ?? this.title,
      abstract: abstract ?? this.abstract,
      citation: citation ?? this.citation,
      authors: authors ?? this.authors,
      categories: categories ?? this.categories,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
  
}
