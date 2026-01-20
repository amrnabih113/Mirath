import 'package:mirath/features/auth/data/models/auth_user_data.dart';

/// Response model for authentication endpoints (login, google auth, refresh).
///
/// Contains access token and user data returned from the server.
/// Refresh token is handled via HttpOnly cookies.
class AuthResponseModel {
  final String? accessToken;
  final String? message;
  final AuthUserData? user;

  const AuthResponseModel({
    this.accessToken, 
    this.message, 
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String?,
      message: json['message'] as String?,
      user: json['user'] != null ? AuthUserData.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'message': message,
      'user': user?.toJson(),
    };
  }
}
