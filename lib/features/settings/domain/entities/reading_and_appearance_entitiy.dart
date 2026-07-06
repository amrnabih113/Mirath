// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:mirath/core/utils/my_enums.dart';

class ReadingAndAppearanceEntitiy extends Equatable {
  final ColorMode colorMode;
  final FontSize defaultFontSize;
  final Visible defaultReadingListVisibility;
  final List<String> annotationHighlightColors;
  const ReadingAndAppearanceEntitiy({
    required this.colorMode,
    required this.defaultFontSize,
    required this.defaultReadingListVisibility,
    required this.annotationHighlightColors,
  });

  ReadingAndAppearanceEntitiy copyWith({
    ColorMode? colorMode,
    FontSize? defaultFontSize,
    Visible? defaultReadingListVisibility,
    List<String>? annotationHighlightColors,
  }) {
    return ReadingAndAppearanceEntitiy(
      colorMode: colorMode ?? this.colorMode,
      defaultFontSize: defaultFontSize ?? this.defaultFontSize,
      defaultReadingListVisibility:
          defaultReadingListVisibility ?? this.defaultReadingListVisibility,
      annotationHighlightColors:
          annotationHighlightColors ?? this.annotationHighlightColors,
    );
  }

  @override
  List<Object?> get props => [
    colorMode,
    defaultFontSize,
    defaultReadingListVisibility,
    annotationHighlightColors,
  ];
}
