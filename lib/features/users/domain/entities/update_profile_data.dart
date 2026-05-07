import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileData extends Equatable {
  final String? bio;
  final String? country;
  final String? fullName;
  final List<String>? interests;
  final bool? keepEmailPrivate;
  final String? levelOfEducation;
  final XFile? profilePhoto;
  final String? university;

  const UpdateProfileData({
    this.bio,
    this.country,
    this.fullName,
    this.interests,
    this.keepEmailPrivate,
    this.levelOfEducation,
    this.profilePhoto,
    this.university,
  });

  @override
  List<Object?> get props => [
    bio,
    country,
    fullName,
    interests,
    keepEmailPrivate,
    levelOfEducation,
    profilePhoto,
    university,
  ];
}
