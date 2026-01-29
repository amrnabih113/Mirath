import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/auth_response_model.dart';
import '../models/check_setup_response_model.dart';
import '../models/is_verified_response_model.dart';
import '../models/signup_response_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<SignupResponseModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _dioClient.post(
      MyConstants.signUp,
      data: {
        'email': email,
        'username': username,
        'password': password,
        'confirmPassword': password,
      },
    );
    return SignupResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> signin({
    required String emailOrUsername,
    required String password,
  }) async {
    final response = await _dioClient.post(
      MyConstants.login,
      data: {'emailOrUsername': emailOrUsername, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> signout() async {
    await _dioClient.post(MyConstants.logout);
  }

  @override
  Future<String> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await _dioClient.post(
      MyConstants.verifyEmail,
      data: {'email': email, 'otp': otp},
    );

    // Extract access token from response
    final data = response.data as Map<String, dynamic>;
    return data['accessToken'] as String? ?? '';
  }

  @override
  Future<void> resendVerification({required String email}) async {
    await _dioClient.post(
      MyConstants.resendVerification,
      data: {'email': email},
    );
  }

  @override
  Future<AuthResponseModel> googleAuth({required String idToken}) async {
    final response = await _dioClient.post(
      MyConstants.google,
      data: {'idToken': idToken},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await _dioClient.post(MyConstants.forgetPassword, data: {'email': email});
  }

  @override
  Future<String> verifyResetCode({
    required String email,
    required String otp,
  }) async {
    final response = await _dioClient.post(
      MyConstants.verifyResetPasswordOTP,
      data: {'email': email, 'otp': otp},
    );
    // Extract reset token from response
    final data = response.data as Map<String, dynamic>;
    return data['resetToken'] as String? ?? '';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String password,
  }) async {
    await _dioClient.post(
      MyConstants.resetPassword,
      data: {
        'resetToken': resetToken,
        'password': password,
        'confirmPassword': password,
      },
    );
  }

  @override
  Future<IsVerifiedResponseModel> isVerified({required String email}) async {
    final response = await _dioClient.post(
      MyConstants.isVerified,
      data: {'email': email},
    );
    return IsVerifiedResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<CheckSetupResponseModel> checkSetup() async {
    final response = await _dioClient.get(MyConstants.checkSetup);
    return CheckSetupResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
