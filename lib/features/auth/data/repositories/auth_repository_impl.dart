import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mirath/core/utils/my_constants.dart';
import 'package:mirath/core/utils/my_logger.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/signin_data.dart';
import '../../domain/entities/signup_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  String? _cachedEmail;
  String? _cachedResetToken;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage;

  @override
  Future<Either<Failure, void>> signIn(SigninData signinData) async {
    try {
      final response = await _remoteDataSource.signin(
        emailOrUsername: signinData.email,
        password: signinData.password,
      );

      // Save access token if returned
      if (response.accessToken != null) {
        await _secureStorage.saveAccessToken(response.accessToken!);
      }

      // Cache email for verification flows
      _cachedEmail = signinData.email;
      await _secureStorage.saveEmail(_cachedEmail!);

      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(SignupData signupData) async {
    try {
      await _remoteDataSource.signUp(
        email: signupData.email,
        password: signupData.password,
        username: signupData.username,
      );

      // Cache email for verification
      _cachedEmail = signupData.email;
      await _secureStorage.saveEmail(_cachedEmail!);

      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signout();
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Ignore errors from Google sign out
      }
      _cachedEmail = null;
      await _secureStorage.clearEmail();
      await _secureStorage.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      return Right(await _secureStorage.getAccessToken() != null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isVerified() async {
    try {
      final email = _cachedEmail ??= await _secureStorage.getEmail();
      if (email == null) {
        return const Left(UnauthorizedFailure('No user email cached'));
      }

      final response = await _remoteDataSource.isVerified(email: email);
      return Right(response.isVerified);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signinWithGoogle() async {
    try {
      MyLogger.debug("Starting Google Sign-In process...");
      MyLogger.debug("Platform: ${kIsWeb ? 'Web' : 'Mobile'}");

      // Create Google Sign-In instance with platform-specific configuration
      final GoogleSignIn googleSignIn;

      if (kIsWeb) {
        MyLogger.debug("Web platform: Creating instance with clientId");
        googleSignIn = GoogleSignIn(clientId: MyConstants.googleServerClientId);
        MyLogger.debug("Web instance created");
      } else {
        MyLogger.debug(
          "Mobile platform: Creating instance with serverClientId",
        );
        googleSignIn = GoogleSignIn(
          serverClientId: MyConstants.googleServerClientId,
        );
        MyLogger.debug("Mobile instance created");
      }

      GoogleSignInAccount? account;

      // Use the standard signIn() method
      MyLogger.debug("Attempting Google Sign-In with user interaction...");
      account = await googleSignIn.signIn();

      if (account == null) {
        MyLogger.debug("Google Sign-In returned null - user likely canceled");
        return const Left(ServerFailure("Google Sign-In was canceled"));
      }

      MyLogger.debug("Google Sign-In successful!");
      MyLogger.debug("User: ${account.displayName} (${account.email})");

      // Get authentication details
      MyLogger.debug("Getting authentication token...");
      final GoogleSignInAuthentication authentication =
          await account.authentication;
      final String? idToken = authentication.idToken;

      if (idToken == null) {
        MyLogger.debug("Failed to get ID token");
        return const Left(ServerFailure('Failed to get Google ID token'));
      }

      MyLogger.debug("ID token obtained successfully");
      // Authenticate with backend
      MyLogger.debug("Authenticating with backend...");
      final response = await _remoteDataSource.googleAuth(idToken: idToken);

      // Save access token
      if (response.accessToken != null) {
        await _secureStorage.saveAccessToken(response.accessToken!);
        MyLogger.debug("Access token saved");
      }

      _cachedEmail = account.email;
      MyLogger.debug("Google Sign-In process completed successfully!");
      return const Right(null);
    } catch (e) {
      MyLogger.debug("Google Sign-In failed: $e");
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signinWithApple() async {
    try {
      // Apple Sign-In implementation
      // This requires sign_in_with_apple package
      // For now, return not implemented
      return const Left(ServerFailure('Apple Sign-In not yet implemented'));
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationOTP() async {
    try {
      final email = _cachedEmail ??= await _secureStorage.getEmail();
      if (email == null) {
        return const Left(UnauthorizedFailure('No user email cached'));
      }

      await _remoteDataSource.resendVerification(email: email);
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyAccount(String otp) async {
    try {
      final email = _cachedEmail ??= await _secureStorage.getEmail();
      if (email == null) {
        return const Left(UnauthorizedFailure('No user email cached'));
      }
      await _remoteDataSource.verifyEmail(email: email, otp: otp);
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword(String email) async {
    try {
      await _remoteDataSource.forgetPassword(email: email);
      // Cache email for subsequent OTP verification
      _cachedEmail = email;
      await _secureStorage.saveEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyResetPasswordOTP(String otp) async {
    try {
      final email = _cachedEmail ??= await _secureStorage.getEmail();
      if (email == null) {
        return const Left(UnauthorizedFailure('No email for password reset'));
      }
      final resetToken = await _remoteDataSource.verifyResetCode(
        email: email,
        otp: otp,
      );

      _cachedResetToken = resetToken;

      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String newPassword) async {
    try {
      if (_cachedResetToken == null) {
        return const Left(UnauthorizedFailure('No reset token available'));
      }

      await _remoteDataSource.resetPassword(
        resetToken: _cachedResetToken!,
        password: newPassword,
      );

      // Clear cached reset token
      _cachedResetToken = null;

      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> setUpProfile(UserProfile userProfile) async {
    try {
      // Convert entity to model for serialization
      // ignore: unused_local_variable
      final profileModel = UserProfileModel.fromEntity(userProfile);

      // TODO: Add profile setup endpoint to remote data source when API is available
      // For now, this is a placeholder
      // await _remoteDataSource.setUpProfile(profileModel);

      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
