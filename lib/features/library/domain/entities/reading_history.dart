import 'package:mirath/features/home/domain/entities/paper_entity.dart';

class ReadingHistoryPaper {
  final String paperId;
  final DateTime viewedAt;
  final PaperEntity paper;

  ReadingHistoryPaper({
    required this.paperId,
    required this.viewedAt,
    required this.paper,
  });
}
