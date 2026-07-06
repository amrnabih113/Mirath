enum DeviceType { mobile, tablet, web }

enum ColorMode { LIGHT, DARK, SYSTEM }

extension ColorModeX on ColorMode {
  String get label => switch (this) {
    ColorMode.LIGHT => 'Light mode',
    ColorMode.DARK => 'Dark mode',
    ColorMode.SYSTEM => 'System',
  };
}

enum FontSize { SMALL, MEDIUM, LARGE, EXTRA_LARG }

extension FontSizeX on FontSize {
  String get label => switch (this) {
    FontSize.SMALL => 'Small',
    FontSize.MEDIUM => 'Medium',
    FontSize.LARGE => 'Large',
    FontSize.EXTRA_LARG => 'Extra Large',
  };
}

enum Visible { PUBLIC, PRIVATE }

extension VisibleModeX on Visible {
  String get label => switch (this) {
    Visible.PRIVATE => 'Privet',
    Visible.PUBLIC => 'Public',
  };
}

enum ExportListFormate { json, bibtex, csv }

enum ExportAnnotationsFormate { json, markdown }

enum EducationLevel {
  highSchool,
  underGraduate,
  graduated;

  /// Convert enum value to server-expected format
  String get serverValue {
    switch (this) {
      case EducationLevel.highSchool:
        return 'HIGH_SCHOOL';
      case EducationLevel.underGraduate:
        return 'UNDERGRADUATE';
      case EducationLevel.graduated:
        return 'GRADUATE';
    }
  }
}
