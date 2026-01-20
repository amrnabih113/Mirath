enum DeviceType { mobile, tablet, web }

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
