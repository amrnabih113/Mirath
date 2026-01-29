import '../../domain/entities/user.dart';

class InterestModel extends Interest {
  const InterestModel({
    required super.id,
    required super.name,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
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
