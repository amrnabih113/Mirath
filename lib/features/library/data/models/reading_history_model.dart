import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/papers/data/models/paper_model.dart';

class ReadingHistoryModel {
  final int size;
  final List<ReadingHistoryPaper> data;

  ReadingHistoryModel({required this.size, required this.data});

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryModel(
      size: json['size'] ?? 0,
      data:
          (json['data'] as List?)
              ?.map(
                (e) => ReadingHistoryPaper(
                  paperId: e['paperId'] ?? '',
                  viewedAt: e['viewedAt'] != null
                      ? DateTime.parse(e['viewedAt'])
                      : DateTime.now(),
                  paper: PaperModel.fromJson(e['paper']),
                ),
              )
              .toList() ??
          [],
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
