import '../../domain/entities/reading_and_appearance_entitiy.dart';

class ReadingAndAppearanceModel extends ReadingAndAppearanceEntitiy {
  ReadingAndAppearanceModel({
    required super.colorMode,
    required super.defaultFontSize,
    required super.defaultReadingListVisibility,
    required super.annotationHighlightColors,
  });

  factory ReadingAndAppearanceModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ReadingAndAppearanceModel(
      colorMode: data['colorMode'] as String,
      defaultFontSize: data['defaultFontSize'] as String,
      defaultReadingListVisibility:
          data['defaultReadingListVisibility'] as String,
      annotationHighlightColors: List<String>.from(
        data['annotationHighlightColors'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'colorMode': colorMode,
    'defaultFontSize': defaultFontSize,
    'defaultReadingListVisibility': defaultReadingListVisibility,
    'annotationHighlightColors': annotationHighlightColors,
  };
}
