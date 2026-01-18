/// Response model for authentication endpoints (login, google auth, refresh).
///
/// Contains access token returned from the server.
/// Refresh token is handled via HttpOnly cookies.
class AuthResponseModel {
  final String? accessToken;
  final String? message;

  const AuthResponseModel({this.accessToken, this.message});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'message': message};
  }
}
