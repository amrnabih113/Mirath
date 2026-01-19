/// Response model for verify-reset-code endpoint.
///
/// Contains the reset token needed for password reset.
class ResetTokenResponseModel {
  final String resetToken;
  final String? message;

  const ResetTokenResponseModel({required this.resetToken, this.message});

  factory ResetTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetTokenResponseModel(
      resetToken: json['resetToken'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'resetToken': resetToken, 'message': message};
  }
}
