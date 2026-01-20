import 'package:equatable/equatable.dart';

class ProfileSetupData extends Equatable {
  final List<String> interests;
  final String levelOfEducation;
  final String name;
  final String? university;

  const ProfileSetupData({
    required this.interests,
    required this.levelOfEducation,
    required this.name,
    this.university,
  });

  @override
  List<Object?> get props => [interests, levelOfEducation, name, university];

  ProfileSetupData copyWith({
    List<String>? interests,
    String? levelOfEducation,
    String? name,
    String? university,
  }) {
    return ProfileSetupData(
      interests: interests ?? this.interests,
      levelOfEducation: levelOfEducation ?? this.levelOfEducation,
      name: name ?? this.name,
      university: university ?? this.university,
    );
  }
}
