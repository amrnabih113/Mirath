import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../entities/signin_data.dart';
import '../entities/signup_data.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signIn(SigninData signinData);
  Future<Either<Failure, void>> signUp(SignupData signupData);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, void>> signinWithGoogle();
  Future<Either<Failure, void>> signinWithApple();
  Future<Either<Failure, void>> sendOTP();
  Future<Either<Failure, void>> verifyOTP(String otp);
  Future<Either<Failure, void>> resetPassword();
  Future<Either<Failure, String?>> getUserEmail();
}