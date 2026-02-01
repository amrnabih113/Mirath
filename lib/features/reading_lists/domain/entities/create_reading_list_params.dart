class CreateReadingListParams {
  final String title;
  final String? description;
  final bool isPublic;

  const CreateReadingListParams({
    required this.title,
    this.description,
    this.isPublic = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'isPublic': isPublic,
    };
  }
}
