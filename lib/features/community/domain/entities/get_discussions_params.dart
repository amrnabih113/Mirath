class GetDiscussionsParams {
  final int page;
  final int limit;
  final String sort;
  final String? topicId;

  const GetDiscussionsParams({
    this.page = 1,
    this.limit = 10,
    this.sort = 'new',
    this.topicId,
  });
}
