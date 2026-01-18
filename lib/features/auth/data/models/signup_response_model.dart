/// Response model for signup endpoint.
///
/// Example response:
/// ```json
/// {
///   "message": "Signup successful. Please check your email for the verification code.",
///   "userId": "123e4567-e89b-12d3-a456-426614174000"
/// }
/// ```
class SignupResponseModel {
  final String message;
  final String userId;

  const SignupResponseModel({required this.message, required this.userId});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      message: json['message'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'userId': userId};
  }
}
