import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/papers/data/models/paper_model.dart';

class ReadingHistoryModel {
  final int size;
  final List<ReadingHistoryPaper> data;

  ReadingHistoryModel({required this.size, required this.data});

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List? ?? [];

    return ReadingHistoryModel(
      size: json['size'] ?? 0,
      data: rawData.map((e) {
        final item = e as Map<String, dynamic>? ?? {};
        final viewedAtRaw = item['viewedAt']?.toString();

        return ReadingHistoryPaper(
          paperId: item['paperId'] ?? '',
          viewedAt: DateTime.tryParse(viewedAtRaw ?? '') ?? DateTime.now(),
          paper: PaperModel.fromJson(
            item['paper'] as Map<String, dynamic>? ?? {},
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'data': data
          .map(
            (e) => {
              'paperId': e.paperId,
              'viewedAt': e.viewedAt.toIso8601String(),
              'paper': (e.paper as PaperModel).toJson(),
            },
          )
          .toList(),
    };
  }
}
