import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/utils/my_constants.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/signin_data.dart';
import '../../domain/entities/signup_data.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;
  final UserCacheService _userCache;
  final LocalStorageService _localStorage;
  final HiveCacheService _cacheService;

  String? _cachedEmail;
  String? _cachedResetToken;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
    required UserCacheService userCache,
    required LocalStorageService localStorage,
    required HiveCacheService cacheService,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage,
       _userCache = userCache,
       _localStorage = localStorage,
       _cacheService = cacheService;

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

      // Cache user data if returned
      if (response.user != null) {
        await _userCache.saveUser(response.user!);
        MyLogger.info('[AuthRepository] User data cached successfully');
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
      try {
        await _remoteDataSource.signout();
      } catch (_) {
        // Logout should still clear local state even when the network is down.
      }
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Ignore errors from Google sign out
      }
      _cachedEmail = null;
      await _secureStorage.clearEmail();
      await _secureStorage.clearTokens();
      await _userCache.clearUser();
      await _localStorage.removeData(MyConstants.userDataKey);
      await _localStorage.clearAll();
      await _cacheService.clearAll();

      MyLogger.info('[AuthRepository] User cache cleared on signout');
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

      // Clear any cached Google session first so we request a fresh ID token.
      // This avoids reusing a stale credential that the backend can reject.
      try {
        await googleSignIn.signOut();
      } catch (_) {
        // Best effort only.
      }

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

      MyLogger.debug(
        "Google ID token acquired for ${account.email}; sending to backend",
      );

      MyLogger.debug("ID token obtained successfully");
      // Authenticate with backend
      MyLogger.debug("Authenticating with backend...");
      final response = await _remoteDataSource.googleAuth(idToken: idToken);

      // Save access token
      if (response.accessToken != null) {
        await _secureStorage.saveAccessToken(response.accessToken!);
        MyLogger.debug("Access token saved");
      }

      // Cache user data if available in response
      if (response.user != null) {
        await _userCache.saveUser(response.user!);
        MyLogger.debug("User data cached successfully");
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
      final response = await _remoteDataSource.verifyEmail(
        email: email,
        otp: otp,
      );

      // Save access token
      if (response.accessToken != null) {
        await _secureStorage.saveAccessToken(response.accessToken!);
      }

      // Cache user data if available (refresh token is in HttpOnly cookie)
      if (response.user != null) {
        await _userCache.saveUser(response.user!);
        MyLogger.info(
          '[AuthRepository] User data cached after email verification',
        );
      }

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
  Future<Either<Failure, bool>> checkSetup() async {
    try {
      // First check local cache
      final cachedStatus = await _secureStorage.getSetupStatus();
      if (cachedStatus != null) {
        return Right(cachedStatus);
      }

      // If no cached value, fetch from API
      final response = await _remoteDataSource.checkSetup();
      final isSetupCompleted = response.isSetupCompleted;

      // Cache the result for future use
      await _secureStorage.saveSetupStatus(isSetupCompleted);

      return Right(isSetupCompleted);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
