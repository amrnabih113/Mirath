import 'user_model.dart';

class ProfileHeaderResponseModel {
  final String message;
  final UserModel profile;

  const ProfileHeaderResponseModel({
    required this.message,
    required this.profile,
  });

  factory ProfileHeaderResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API response
    // The user profile data is directly in the 'data' field
    final userData = json['data'] as Map<String, dynamic>?;

    return ProfileHeaderResponseModel(
      message: json['message'] ?? '',
      profile: UserModel.fromJson(userData ?? {}),
    );
  }
}
