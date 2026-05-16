import '../../../papers/data/models/paper_model.dart';
import '../../domain/entities/reading_list_paper.dart';

class ReadingListPaperModel extends ReadingListPaper {
  const ReadingListPaperModel({
    required super.readingListId,
    required super.paperId,
    super.paper,
  });

  factory ReadingListPaperModel.fromJson(Map<String, dynamic> json) {
    return ReadingListPaperModel(
      readingListId: json['readingListId'] ?? '',
      paperId: json['paperId'] ?? '',
      paper: json['paper'] != null
          ? PaperModel.fromJson(json['paper'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'readingListId': readingListId,
      'paperId': paperId,
      if (paper != null) 'paper': (paper as PaperModel).toJson(),
    };
  }
}
