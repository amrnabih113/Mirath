import '../../domain/entities/interest.dart';

class InterestModel extends Interest {
  const InterestModel({
    required super.id,
    required super.name,
    required super.custom,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      custom: json['custom'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'custom': custom,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Interest toEntity() {
    return Interest(
      id: id,
      name: name,
      custom: custom,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
