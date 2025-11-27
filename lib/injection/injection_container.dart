import 'package:get_it/get_it.dart';
import 'package:mirath/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/is_signed_in_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/is_verified_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/send_verification_otp_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/signin_with_apple_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/signout_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/verify_account_usecase.dart';
import 'package:mirath/features/auth/domain/usecases/verify_reset_password_otp_usecase.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:mirath/features/auth/data/repositories/fake_auth_repository_impl.dart';
import 'package:mirath/features/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

class DI {
  static Future<void> init() async {
    // Core

    //! Features

    //================ Splash ========================
    /// Splash Cubit ///
    sl.registerFactory(
      () => SplashCubit(isSignedInUseCase: sl(), isVerifiedUseCase: sl()),
    );

    //================ Authentication ========================

    /// Auth Repository ///
    sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepositoryImpl());

    /// Auth UseCases ///
    sl.registerLazySingleton(() => SignInUseCase(sl()));
    sl.registerLazySingleton(() => SignUpUseCase(sl()));
    sl.registerLazySingleton(() => SignOutUseCase(sl()));
    sl.registerLazySingleton(() => IsSignedInUseCase(sl()));
    sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
    sl.registerLazySingleton(() => SignInWithAppleUseCase(sl()));
    sl.registerLazySingleton(() => SendVerificationOTPUseCase(sl()));
    sl.registerLazySingleton(() => VerifyOTPUseCase(sl()));
    sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
    sl.registerLazySingleton(() => VerifyResetPasswordOTPUseCase(sl()));
    sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
    sl.registerLazySingleton(() => IsVerifiedUseCase(sl()));

    /// Auth Cubit ///
    sl.registerFactory(
      () => AuthCubit(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        isSignedInUseCase: sl(),
        signInWithGoogleUseCase: sl(),
        signInWithAppleUseCase: sl(),
        sendVerificationOTPUseCase: sl(),
        verifyOTPUseCase: sl(),
        forgetPasswordUseCase: sl(),
        verifyResetPasswordOTPUseCase: sl(),
        resetPasswordUseCase: sl(),
        isVerifiedUseCase: sl(),
      ),
    ); // Cubit
  }
}
