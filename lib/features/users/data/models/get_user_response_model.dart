import 'user_model.dart';

class GetUserResponseModel {
  final String message;
  final UserModel data;

  const GetUserResponseModel({required this.message, required this.data});

  factory GetUserResponseModel.fromJson(Map<String, dynamic> json) {
    return GetUserResponseModel(
      message: json['message'] ?? '',
      data: UserModel.fromJson(json['data'] ?? {}),
    );
  }

}
