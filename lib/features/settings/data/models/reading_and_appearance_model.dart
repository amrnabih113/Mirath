import 'package:mirath/core/utils/my_enums.dart';

import '../../domain/entities/reading_and_appearance_entitiy.dart';

class ReadingAndAppearanceModel extends ReadingAndAppearanceEntitiy {
  const ReadingAndAppearanceModel({
    required super.colorMode,
    required super.defaultFontSize,
    required super.defaultReadingListVisibility,
    required super.annotationHighlightColors,
  });

  factory ReadingAndAppearanceModel.fromJson(
    Map<String, dynamic> json, {
    ReadingAndAppearanceEntitiy? previous,
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return ReadingAndAppearanceModel(
      colorMode: data['colorMode'] != null
          ? ColorMode.values.firstWhere(
              (e) => e.name.toUpperCase() == data['colorMode'],
              orElse: () => previous?.colorMode ?? ColorMode.SYSTEM,
            )
          : previous?.colorMode ?? ColorMode.SYSTEM,

      defaultFontSize: data['defaultFontSize'] != null
          ? FontSize.values.firstWhere(
              (e) => e.name.toUpperCase() == data['defaultFontSize'],
              orElse: () => previous?.defaultFontSize ?? FontSize.MEDIUM,
            )
          : previous?.defaultFontSize ?? FontSize.MEDIUM,

      defaultReadingListVisibility: data['defaultReadingListVisibility'] != null
          ? Visible.values.firstWhere(
              (e) =>
                  e.name.toUpperCase() == data['defaultReadingListVisibility'],
              orElse: () =>
                  previous?.defaultReadingListVisibility ?? Visible.PUBLIC,
            )
          : previous?.defaultReadingListVisibility ?? Visible.PUBLIC,

      annotationHighlightColors: data['annotationHighlightColors'] != null
          ? List<String>.from(data['annotationHighlightColors'])
          : previous?.annotationHighlightColors ?? [],
    );
  }
  factory ReadingAndAppearanceModel.partial(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ReadingAndAppearanceModel(
      colorMode: ColorMode.values.firstWhere(
        (e) => e.name.toUpperCase() == data['colorMode'],
      ),
      defaultFontSize: FontSize.values.firstWhere(
        (e) => e.name.toUpperCase() == data['defaultFontSize'],
      ),
      defaultReadingListVisibility: Visible.PUBLIC, // dummy، مش هيتستخدم
      annotationHighlightColors: [], // dummy، مش هيتستخدم
    );
  }
  factory ReadingAndAppearanceModel.partialVisibility(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ReadingAndAppearanceModel(
      defaultReadingListVisibility: Visible.values.firstWhere(
        (e) => e.name.toUpperCase() == data['defaultReadingListVisibility'],
      ),
      annotationHighlightColors: List<String>.from(
        data['annotationHighlightColors'] ?? [],
      ),
      // dummy values - مش هيتستخدموا
      colorMode: ColorMode.SYSTEM,
      defaultFontSize: FontSize.MEDIUM,
    );
  }

  Map<String, dynamic> toJson() => {
    'colorMode': colorMode.name.toUpperCase(),
    'defaultFontSize': defaultFontSize.name.toUpperCase(),
    'defaultReadingListVisibility': defaultReadingListVisibility.name
        .toUpperCase(),
    'annotationHighlightColors': annotationHighlightColors,
  };
}
