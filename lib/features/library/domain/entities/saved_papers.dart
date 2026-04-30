import 'package:mirath/features/papers/data/models/full_paper_model.dart';

class SavedPapers {
  final String userId, paperId;
  final List<FullPaperModel> paper;
  final DateTime createdAt;
  final List<String> authors;
  final int size;

  SavedPapers({
    required this.userId,
    required this.paperId,
    required this.paper,
    required this.createdAt,
    required this.authors,
    required this.size,
  });
}
