import '../../../home/domain/entities/paper_entity.dart';

class ReadingListPaper {
  final String readingListId;
  final String paperId;
  final PaperEntity? paper;

  const ReadingListPaper({
    required this.readingListId,
    required this.paperId,
    this.paper,
  });

  ReadingListPaper copyWith({
    String? readingListId,
    String? paperId,
    PaperEntity? paper,
  }) {
    return ReadingListPaper(
      readingListId: readingListId ?? this.readingListId,
      paperId: paperId ?? this.paperId,
      paper: paper ?? this.paper,
    );
  }
}
