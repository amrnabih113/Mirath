import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../domain/entities/signin_data.dart';
import '../../domain/entities/signup_data.dart';
import '../../domain/repositories/auth_repository.dart';

/// Fake implementation of AuthRepository for testing purposes
/// This simulates authentication flows without requiring backend services
class FakeAuthRepositoryImpl implements AuthRepository {
  // Simulate user state
  bool _isSignedIn = false;
  bool _isVerified = false;
  bool _otpSent = false;
  bool _resetOtpSent = false;
  String? _currentEmail;
  // ignore: unused_field
  String? _currentPassword;

  // Fake user credentials for testing
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String validOtp = '123456';

  @override
  Future<Either<Failure, void>> signIn(SigninData signinData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate credentials
    if (signinData.email == validEmail &&
        signinData.password == validPassword) {
      _isSignedIn = true;
      _isVerified = false; // New sign-ins are unverified
      _currentEmail = signinData.email;
      _currentPassword = signinData.password;
      return const Right(null);
    } else {
      return Left(ServerFailure('Invalid email or password'));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(SignupData signupData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists
    if (signupData.email == validEmail) {
      return Left(ServerFailure('Email already exists'));
    }

    // Simulate successful signup
    _isSignedIn = true;
    _isVerified = false;
    _currentEmail = signupData.email;
    _currentPassword = signupData.password;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _isSignedIn = false;
    _isVerified = false;
    _otpSent = false;
    _resetOtpSent = false;
    _currentEmail = null;
    _currentPassword = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    // Simulate checking auth state
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_isSignedIn);
  }

  @override
  Future<Either<Failure, bool>> isVerified() async {
    // Simulate checking verification state
    await Future.delayed(const Duration(milliseconds: 300));

    if (!_isSignedIn) {
      return Left(ServerFailure('User not signed in'));
    }

    return Right(_isVerified);
  }

  @override
  Future<Either<Failure, void>> signinWithGoogle() async {
    // Simulate Google Sign-In
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful Google sign-in
    _isSignedIn = true;
    _isVerified = true; // Google accounts are auto-verified
    _currentEmail = 'google.user@gmail.com';
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> signinWithApple() async {
    // Simulate Apple Sign-In
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful Apple sign-in
    _isSignedIn = true;
    _isVerified = true; // Apple accounts are auto-verified
    _currentEmail = 'apple.user@icloud.com';
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> sendVerificationOTP() async {
    // Simulate sending OTP
    await Future.delayed(const Duration(seconds: 1));

    if (!_isSignedIn) {
      return Left(ServerFailure('User not signed in'));
    }

    if (_isVerified) {
      return Left(ServerFailure('User already verified'));
    }

    _otpSent = true;
    // In real app, OTP would be sent to email/phone
    print('Fake OTP sent: $validOtp to $_currentEmail');
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> verifyAccount(String otp) async {
    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 1));

    if (!_isSignedIn) {
      return Left(ServerFailure('User not signed in'));
    }

    if (!_otpSent) {
      return Left(ServerFailure('OTP not sent. Please request OTP first'));
    }

    if (otp == validOtp) {
      _isVerified = true;
      _otpSent = false;
      return const Right(null);
    } else {
      return Left(ServerFailure('Invalid OTP'));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword() async {
    // Simulate sending password reset OTP
    await Future.delayed(const Duration(seconds: 1));

    if (_currentEmail == null) {
      return Left(ServerFailure('Email not found'));
    }

    _resetOtpSent = true;
    // In real app, OTP would be sent to email
    print('Fake Reset OTP sent: $validOtp to $_currentEmail');
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> verifyResetPasswordOTP(String otp) async {
    // Simulate OTP verification for password reset
    await Future.delayed(const Duration(seconds: 1));

    if (!_resetOtpSent) {
      return Left(
        ServerFailure(
          'Reset OTP not sent. Please request password reset first',
        ),
      );
    }

    if (otp == validOtp) {
      return const Right(null);
    } else {
      return Left(ServerFailure('Invalid OTP'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String newPassword) async {
    // Simulate password reset
    await Future.delayed(const Duration(seconds: 1));

    if (!_resetOtpSent) {
      return Left(ServerFailure('OTP verification required'));
    }

    if (newPassword.length < 6) {
      return Left(ServerFailure('Password must be at least 6 characters'));
    }

    _currentPassword = newPassword;
    _resetOtpSent = false;
    return const Right(null);
  }

  // Helper method to reset state for testing
  void resetState() {
    _isSignedIn = false;
    _isVerified = false;
    _otpSent = false;
    _resetOtpSent = false;
    _currentEmail = null;
    _currentPassword = null;
  }

  // Helper method to set custom state for testing
  void setCustomState({bool? isSignedIn, bool? isVerified, String? email}) {
    if (isSignedIn != null) _isSignedIn = isSignedIn;
    if (isVerified != null) _isVerified = isVerified;
    if (email != null) _currentEmail = email;
  }
}
