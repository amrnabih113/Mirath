class DiscussionPaper {
  final String id;
  final List<String> authors;
  final String title;
  final String abstract;

  const DiscussionPaper({
    required this.id,
    required this.authors,
    required this.title,
    required this.abstract,
  });

  DiscussionPaper copyWith({
    String? id,
    List<String>? authors,
    String? title,
    String? abstract,
  }) {
    return DiscussionPaper(
      id: id ?? this.id,
      authors: authors ?? this.authors,
      title: title ?? this.title,
      abstract: abstract ?? this.abstract,
    );
  }
}
