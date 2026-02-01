class AddPaperToListParams {
  final String readingListId;
  final String paperId;

  const AddPaperToListParams({
    required this.readingListId,
    required this.paperId,
  });

  Map<String, dynamic> toJson() {
    return {'paperId': paperId};
  }
}
