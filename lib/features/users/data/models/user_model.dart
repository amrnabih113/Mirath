import '../../domain/entities/user.dart';
import 'field_of_study_model.dart';
import 'interest_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.fullName,
    super.photoUrl,
    super.bio,
    super.birthDate,
    super.country,
    required super.levelOfEducation,
    super.university,
    required super.role,
    required super.status,
    required super.isEmailVisible,
    required super.isPremium,
    required super.createdAt,
    required super.updatedAt,
    required super.interests,
    required super.fieldsOfStudy,
    required super.followersCount,
    required super.followingCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      country: json['country'],
      levelOfEducation: json['levelOfEducation'] ?? '',
      university: json['university'],
      role: json['role'] ?? 'USER',
      status: json['status'] ?? 'ACTIVE',
      isEmailVisible: json['isEmailVisible'] ?? true,
      isPremium: json['isPremium'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      interests: (json['interests'] as List<dynamic>?)
              ?.map((interest) => InterestModel.fromJson(interest))
              .toList() ??
          [],
      fieldsOfStudy: (json['fieldsOfStudy'] as List<dynamic>?)
              ?.map((field) => FieldOfStudyModel.fromJson(field))
              .toList() ??
          [],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'bio': bio,
      'birthDate': birthDate?.toIso8601String(),
      'country': country,
      'levelOfEducation': levelOfEducation,
      'university': university,
      'role': role,
      'status': status,
      'isEmailVisible': isEmailVisible,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'interests': interests.map((interest) => {
            'id': interest.id,
            'name': interest.name,
          }).toList(),
      'fieldsOfStudy': fieldsOfStudy.map((field) => {
            'id': field.id,
            'name': field.name,
          }).toList(),
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }

  factory UserModel.empty() => UserModel(
        id: '',
        email: '',
        username: '',
        fullName: '',
        photoUrl: '',
        status: 'ACTIVE',
        levelOfEducation: '',
        university: '',
        role: 'USER',
        isEmailVisible: true,
        isPremium: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        interests: const [],
        fieldsOfStudy: const [],
        followersCount: 0,
        followingCount: 0,
      );
}
