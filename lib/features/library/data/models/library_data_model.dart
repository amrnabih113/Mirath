import 'package:mirath/features/library/domain/entities/library_data.dart';

class LibraryDataModel extends LibraryData {
  LibraryDataModel({
    required super.listsCount,
    required super.createdCount,
    required super.savedCount,
    required super.projectsCount,
  });

  factory LibraryDataModel.fromJson(Map<String, dynamic> json) {
    return LibraryDataModel(
      listsCount: json['listsCount'] ?? 0,
      createdCount: json['createdCount'] ?? 0,
      savedCount: json['savedCount'] ?? 0,
      projectsCount: json['projectsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listsCount': listsCount,
      'createdCount': createdCount,
      'savedCount': savedCount,
      'projectsCount': projectsCount,
    };
  }
}
