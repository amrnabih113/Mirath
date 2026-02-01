class CreateCommentParams {
  final String discussionId;
  final String content;
  final String? parentId;

  const CreateCommentParams({
    required this.discussionId,
    required this.content,
    this.parentId,
  });
}
