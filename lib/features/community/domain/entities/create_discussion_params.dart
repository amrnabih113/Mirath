class CreateDiscussionParams {
  final String title;
  final String content;
  final List<String> topicIds;
  final List<String>? paperIds;

  const CreateDiscussionParams({
    required this.title,
    required this.content,
    required this.topicIds,
    this.paperIds,
  });
}
