import 'user_model.dart';

class ProfileSetupResponseModel {
  final String message;
  final UserModel data;

  const ProfileSetupResponseModel({required this.message, required this.data});

  factory ProfileSetupResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileSetupResponseModel(
      message: json['message'] ?? '',
      data: UserModel.fromJson(json['data'] ?? {}),
    );
  }

}
