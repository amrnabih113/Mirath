import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
// ignore: unused_import
import 'package:mirath/features/auth/data/repositories/fake_auth_repository_impl.dart';
import 'package:mirath/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:mirath/features/home/data/data_sources/home_remote_data_source_impl.dart';
import 'package:mirath/features/home/data/repositories/home_repository_impl.dart';
import 'package:mirath/features/home/domain/repositories/home_repository.dart';
import 'package:mirath/features/home/domain/usecases/get_recent_papers_usecase.dart';
import 'package:mirath/features/home/domain/usecases/get_recommendations_usecase.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_manager.dart';
import '../core/services/local_storage_service.dart';
import '../core/services/secure_storage_service.dart';
import '../core/services/user_cache_service.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/check_setup_usecase.dart';
import '../features/auth/domain/usecases/forget_password_usecase.dart';
import '../features/auth/domain/usecases/is_signed_in_usecase.dart';
import '../features/auth/domain/usecases/is_verified_usecase.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
import '../features/auth/domain/usecases/send_verification_otp_usecase.dart';
import '../features/auth/domain/usecases/signin_usecase.dart';
import '../features/auth/domain/usecases/signin_with_apple_usecase.dart';
import '../features/auth/domain/usecases/signin_with_google_usecase.dart';
import '../features/auth/domain/usecases/signout_usecase.dart';
import '../features/auth/domain/usecases/signup_usecase.dart';
import '../features/auth/domain/usecases/verify_account_usecase.dart';
import '../features/auth/domain/usecases/verify_reset_password_otp_usecase.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
// Interests imports
import '../features/interests/data/data_sources/interests_remote_data_source.dart';
import '../features/interests/data/data_sources/interests_remote_data_source_impl.dart';
import '../features/interests/data/repositories/interests_repository_impl.dart';
import '../features/interests/domain/repositories/interests_repository.dart';
import '../features/interests/domain/usecases/get_all_interests_usecase.dart';
import '../features/interests/domain/usecases/get_interest_by_id_usecase.dart';
import '../features/interests/presentation/cubit/interests_cubit.dart';
// Users imports
import '../features/users/data/data_sources/users_remote_data_source.dart';
import '../features/users/data/data_sources/users_remote_data_source_impl.dart';
import '../features/users/data/repositories/users_repository_impl.dart';
import '../features/users/domain/repositories/users_repository.dart';
import '../features/users/domain/usecases/follow_user_usecase.dart';
import '../features/users/domain/usecases/get_current_user_usecase.dart';
import '../features/users/domain/usecases/setup_profile_usecase.dart';
import '../features/users/domain/usecases/unfollow_user_usecase.dart';

final sl = GetIt.instance;

class DI {
  static Future<void> init() async {
    // Core
    sl.registerLazySingleton(() => DioClient(secureStorage: sl()));
    sl.registerLazySingleton(() => sl<DioClient>().dio);
    sl.registerLazySingleton(() => NetworkManager.instance..initialize());

    /// Local Storage ///
    final localStorage = await LocalStorageService.init();
    sl.registerLazySingleton<LocalStorageService>(() => localStorage);

    /// Secure Storage ///
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    /// User Cache Service ///
    sl.registerLazySingleton<UserCacheService>(() => UserCacheService(sl()));

    //** Features **//

    //================ Authentication ========================

    /// Auth Data Sources ///
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dioClient: sl()),
    );

    // ///   Auth Repository ///
    // ///
    // sl.registerLazySingleton<AuthRepository>(
    //   () => AuthRepositoryImpl(
    //     remoteDataSource: sl(),
    //     secureStorage: sl(),
    //     userCache: sl(),
    //   ),
    // );

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
    sl.registerLazySingleton(() => CheckSetupUseCase(sl()));

    /// Auth Cubit ///
    sl.registerLazySingleton(
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
        setUpProfileUseCase: sl(),
        checkSetupUseCase: sl(),
        localStorage: sl(),
        secureStorage: sl(),
      ),
    ); // Cubit

    //================ Users ========================

    /// Users Data Sources ///
    sl.registerLazySingleton<UsersRemoteDataSource>(
      () => UsersRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Users Repository ///
    sl.registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(remoteDataSource: sl(), networkManager: sl()),
    );

    /// Users UseCases ///
    sl.registerLazySingleton(() => SetupProfileUsecase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
    sl.registerLazySingleton(() => FollowUserUsecase(sl()));
    sl.registerLazySingleton(() => UnfollowUserUsecase(sl()));

    //================ Interests ========================

    /// Interests Data Sources ///
    sl.registerLazySingleton<InterestsRemoteDataSource>(
      () => InterestsRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Interests Repository ///
    sl.registerLazySingleton<InterestsRepository>(
      () =>
          InterestsRepositoryImpl(remoteDataSource: sl(), networkManager: sl()),
    );

    /// Interests UseCases ///
    sl.registerLazySingleton(() => GetAllInterestsUsecase(sl()));
    sl.registerLazySingleton(() => GetInterestByIdUsecase(sl()));

    /// Interests Cubit ///
    sl.registerFactory(
      () => InterestsCubit(
        getAllInterestsUsecase: sl(),
        getInterestByIdUsecase: sl(),
      ),
    );

    //=================== Feed Or Home ========================

    /// Home Data Sources ///
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Home Repository ///
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl(), networkManager: sl()),
    );

    /// Home UseCases ///
    sl.registerLazySingleton(() => GetRecentPapersUseCase(repository: sl()));
    sl.registerLazySingleton(() => GetRecommendationsUseCase(repository: sl()));

    /// Home Cubit ///
    sl.registerFactory(
      () => HomeCubit(
        getRecentPapersUseCase: sl(),
        getRecommendationsUseCase: sl(),
      ),
    );

    
  }
}
