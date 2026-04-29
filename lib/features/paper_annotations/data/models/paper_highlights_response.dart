import 'highlight_model.dart';

class PaperHighlightsResponse {
  final int size;
  final List<HighlightModel> data;

  const PaperHighlightsResponse({required this.size, required this.data});

  factory PaperHighlightsResponse.fromJson(Map<String, dynamic> json) {
    return PaperHighlightsResponse(
      size: json['size'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => HighlightModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HighlightModel>[],
    );
  }
}
