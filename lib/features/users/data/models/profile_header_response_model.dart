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
    // The API response is: { message, data: { profile: {...} } }
    final dataWrapper = json['data'] as Map<String, dynamic>?;
    final userData =
        dataWrapper?['profile'] as Map<String, dynamic>? ?? dataWrapper;

    return ProfileHeaderResponseModel(
      message: json['message'] ?? '',
      profile: UserModel.fromJson(userData ?? {}),
    );
  }
}
