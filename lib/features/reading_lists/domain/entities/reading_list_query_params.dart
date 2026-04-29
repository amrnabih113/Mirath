class ReadingListQueryParams {
  final int page;
  final int limit;
  final String? ownerId;
  final bool saved;
  final bool all;

  const ReadingListQueryParams({
    this.page = 1,
    this.limit = 20,
    this.ownerId,
    this.saved = false,
    this.all = false,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (ownerId != null && ownerId!.isNotEmpty) 'ownerId': ownerId,
      if (saved) 'saved': true,
    };
  }
}
