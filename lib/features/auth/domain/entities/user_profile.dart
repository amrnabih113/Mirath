import 'package:equatable/equatable.dart';

import '../../../../core/utils/my_enums.dart';

class UserProfile extends Equatable {
  final String? name;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final EducationLevel educationLevel;
  final List<String>interests;

  const UserProfile({
    this.name,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    required this.educationLevel, required this.interests,
  });

  @override
  List<Object?> get props => [name, username, email, bio, avatarUrl, educationLevel];

  UserProfile copyWith({
    String? name,
    String? username,
    String? email,
    String? bio,
    String? avatarUrl,
    EducationLevel? educationLevel,
    List<String>? interests,
  }) {
    return UserProfile(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      educationLevel: educationLevel ?? this.educationLevel,
      interests: interests ?? this.interests,
    );
  }
}
