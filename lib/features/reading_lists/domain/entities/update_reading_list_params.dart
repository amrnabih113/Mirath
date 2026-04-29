class UpdateReadingListParams {
  final String readingListId;
  final String? title;
  final String? description;
  final bool? isPublic;

  const UpdateReadingListParams({
    required this.readingListId,
    this.title,
    this.description,
    this.isPublic,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isPublic != null) 'isPublic': isPublic,
    };
  }
}
