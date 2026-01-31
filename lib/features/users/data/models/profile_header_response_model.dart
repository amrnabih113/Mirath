import 'user_model.dart';

class ProfileHeaderResponseModel {
  final String message;
  final UserModel profile;

  const ProfileHeaderResponseModel({
    required this.message,
    required this.profile,
  });

  factory ProfileHeaderResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final profileJson = data?['profile'] as Map<String, dynamic>?;

    return ProfileHeaderResponseModel(
      message: json['message'] ?? '',
      profile: UserModel.fromJson(profileJson ?? {}),
    );
  }
}
