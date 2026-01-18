import 'package:equatable/equatable.dart';

import '../../../../core/utils/my_enums.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel extends Equatable {
  final String? name;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final EducationLevel educationLevel;
  final List<String> interests;

  const UserProfileModel({
    this.name,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    required this.educationLevel,
    required this.interests,
  });

  /// Create model from domain entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      name: entity.name,
      username: entity.username,
      email: entity.email,
      bio: entity.bio,
      avatarUrl: entity.avatarUrl,
      educationLevel: entity.educationLevel,
      interests: entity.interests,
    );
  }

  /// Convert to domain entity
  UserProfile toEntity() {
    return UserProfile(
      name: name,
      username: username,
      email: email,
      bio: bio,
      avatarUrl: avatarUrl,
      educationLevel: educationLevel,
      interests: interests,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String?,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      educationLevel: _parseEducationLevel(json['educationLevel']),
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'educationLevel': educationLevel.name,
      'interests': interests,
    };
  }

  static EducationLevel _parseEducationLevel(dynamic value) {
    if (value == null) return EducationLevel.none;
    if (value is EducationLevel) return value;
    final str = value.toString().toLowerCase();
    return EducationLevel.values.firstWhere(
      (e) => e.name.toLowerCase() == str,
      orElse: () => EducationLevel.none,
    );
  }

  @override
  List<Object?> get props => [
    name,
    username,
    email,
    bio,
    avatarUrl,
    educationLevel,
    interests,
  ];
}
