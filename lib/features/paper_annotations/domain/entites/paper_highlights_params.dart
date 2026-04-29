class PaperHighlightsParams {
  final String paperId;
  final int page;
  final int limit;

  const PaperHighlightsParams({
    required this.paperId,
    this.page = 1,
    this.limit = 20,
  });
}
