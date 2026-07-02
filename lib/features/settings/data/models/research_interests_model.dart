import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';

class ResearchInterestsModel extends ResearchInterestsEntitiy {
  ResearchInterestsModel({required super.id, required super.name});

  factory ResearchInterestsModel.fromJson(Map<String, dynamic> json) {
    return ResearchInterestsModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
