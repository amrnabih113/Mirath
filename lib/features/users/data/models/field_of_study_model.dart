import '../../domain/entities/user.dart';

class FieldOfStudyModel extends FieldOfStudy {
  const FieldOfStudyModel({
    required super.id,
    required super.name,
  });

  factory FieldOfStudyModel.fromJson(Map<String, dynamic> json) {
    return FieldOfStudyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}