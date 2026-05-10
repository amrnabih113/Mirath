class SearchQueryParams {
  final String query;
  final int page;
  final int limit;

  SearchQueryParams({required this.query, this.page = 1, this.limit = 10});
}
