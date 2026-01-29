import '../models/auth_response_model.dart';
import '../models/check_setup_response_model.dart';
import '../models/is_verified_response_model.dart';
import '../models/signup_response_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign up a new user.
  Future<SignupResponseModel> signUp({
    required String email,
    required String password,
    required String username,
  });

  /// Login an existing user.
  Future<AuthResponseModel> signin({
    required String emailOrUsername,
    required String password,
  });

  /// Logout and invalidate current session.
  Future<void> signout();

  /// Verify email with OTP code.
  Future<String> verifyEmail({required String email, required String otp});

  /// Resend verification OTP to email.
  Future<void> resendVerification({required String email});

  /// Authenticate with Google ID token.
  Future<AuthResponseModel> googleAuth({required String idToken});

  /// Request password reset OTP.
  Future<void> forgetPassword({required String email});

  /// Verify password reset OTP and get reset token.
  Future<String> verifyResetCode({required String email, required String otp});

  /// Reset password using reset token.
  Future<void> resetPassword({
    required String resetToken,
    required String password,
  });
  Future<IsVerifiedResponseModel> isVerified({required String email});
  Future<CheckSetupResponseModel> checkSetup();
}
