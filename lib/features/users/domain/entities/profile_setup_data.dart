import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupData extends Equatable {
  final List<String> interests;
  final String levelOfEducation;
  final String name;
  final String? university;
  final XFile? profilePhoto;

  const ProfileSetupData({
    required this.interests,
    required this.levelOfEducation,
    required this.name,
    this.university,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [
    interests,
    levelOfEducation,
    name,
    university,
    profilePhoto,
  ];

  ProfileSetupData copyWith({
    List<String>? interests,
    String? levelOfEducation,
    String? name,
    String? university,
    XFile? profilePhoto,
  }) {
    return ProfileSetupData(
      interests: interests ?? this.interests,
      levelOfEducation: levelOfEducation ?? this.levelOfEducation,
      name: name ?? this.name,
      university: university ?? this.university,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
  
  
}
