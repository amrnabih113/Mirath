import 'package:equatable/equatable.dart';

import '../../../../core/utils/my_enums.dart';

class UserProfile extends Equatable {
  final String? name;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final EducationLevel educationLevel;

  const UserProfile({
    this.name,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    required this.educationLevel,
  });

  @override
  List<Object?> get props => [name, username, email, bio, avatarUrl, educationLevel];
}
