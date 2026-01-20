import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? bio;
  final DateTime? birthDate;
  final String? country;
  final String levelOfEducation;
  final String? university;
  final String role;
  final String status;
  final bool isEmailVisible;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Interest> interests;
  final List<FieldOfStudy> fieldsOfStudy;
  final int followersCount;
  final int followingCount;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.bio,
    this.birthDate,
    this.country,
    required this.levelOfEducation,
    this.university,
    required this.role,
    required this.status,
    required this.isEmailVisible,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
    required this.interests,
    required this.fieldsOfStudy,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    photoUrl,
    bio,
    birthDate,
    country,
    levelOfEducation,
    university,
    role,
    status,
    isEmailVisible,
    isPremium,
    createdAt,
    updatedAt,
    interests,
    fieldsOfStudy,
    followersCount,
    followingCount,
  ];
}

class Interest extends Equatable {
  final String id;
  final String name;

  const Interest({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class FieldOfStudy extends Equatable {
  final String id;
  final String name;

  const FieldOfStudy({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
