import '../../../home/domain/entities/paper_entity.dart';

class SavedPaper {
  final String userId;
  final String paperId;
  final DateTime createdAt;
  final PaperEntity paper;

  SavedPaper({
    required this.userId,
    required this.paperId,
    required this.createdAt,
    required this.paper,
  });
}
