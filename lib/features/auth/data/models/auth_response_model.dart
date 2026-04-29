import 'auth_user_data.dart';

/// Response model for authentication endpoints (login, google auth, refresh).
///
/// Contains access token and user data returned from the server.
/// Refresh token is handled via HttpOnly cookies.
class AuthResponseModel {
  final String? accessToken;
  final String? message;
  final AuthUserData? user;

  const AuthResponseModel({this.accessToken, this.message, this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API response
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return AuthResponseModel(
      accessToken: data['accessToken'] as String?,
      message: json['message'] as String?,
      user: data['user'] != null ? AuthUserData.fromJson(data['user']) : null,
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
