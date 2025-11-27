import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../entities/signin_data.dart';
import '../entities/signup_data.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signIn(SigninData signinData);
  Future<Either<Failure, void>> signUp(SignupData signupData);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, bool>> isVerified();
  Future<Either<Failure, void>> signinWithGoogle();
  Future<Either<Failure, void>> signinWithApple();
  Future<Either<Failure, void>> sendVerificationOTP();
  Future<Either<Failure, void>> verifyAccount(String otp);
  Future<Either<Failure, void>> forgetPassword(String email);
  Future<Either<Failure, void>> verifyResetPasswordOTP(String otp);
  Future<Either<Failure, void>> resetPassword(String newPassword);
}
