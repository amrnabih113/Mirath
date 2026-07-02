enum DeviceType { mobile, tablet, web }

enum ColorMode { light, dark, system }

enum FontSize { small, medium, large, extraLarge }

enum Visible { puplic, privet }

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
