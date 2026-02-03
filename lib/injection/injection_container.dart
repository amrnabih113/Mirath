import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
// ignore: unused_import
import 'package:mirath/features/auth/data/repositories/fake_auth_repository_impl.dart';
import 'package:mirath/features/discussions/data/data_sources/community_remote_data_source.dart';
import 'package:mirath/features/discussions/data/data_sources/community_remote_data_source_impl.dart';
import 'package:mirath/features/discussions/data/repositories/community_repository_impl.dart';
import 'package:mirath/features/discussions/domain/repositories/community_repository.dart';
import 'package:mirath/features/discussions/domain/usecases/create_comment_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/create_discussion_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/delete_comment_vote_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/delete_discussion_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/delete_discussion_vote_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/get_all_discussions_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/get_discussion_by_id_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/get_discussion_comments_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/vote_on_comment_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/vote_on_discussion_usecase.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_cubit.dart';
import 'package:mirath/features/discussions/presentation/cubit/discussion_details_cubit.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/data/data_sources/reading_list_remote_data_source.dart';
import 'package:mirath/features/reading_lists/data/data_sources/reading_list_remote_data_source_impl.dart';
import 'package:mirath/features/reading_lists/data/repositories/reading_list_repository_impl.dart';
import 'package:mirath/features/reading_lists/domain/repositories/reading_list_repository.dart';
import 'package:mirath/features/reading_lists/domain/usecases/add_paper_to_list_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/create_reading_list_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/get_reading_list_by_id_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/get_reading_lists_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/remove_paper_from_list_usecase.dart';
import 'package:mirath/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:mirath/features/home/data/data_sources/home_remote_data_source_impl.dart';
import 'package:mirath/features/home/data/repositories/home_repository_impl.dart';
import 'package:mirath/features/home/domain/repositories/home_repository.dart';
import 'package:mirath/features/home/domain/usecases/get_recent_papers_usecase.dart';
import 'package:mirath/features/home/domain/usecases/get_recommendations_usecase.dart';
import 'package:mirath/features/home/domain/usecases/save_paper_usecase.dart';
import 'package:mirath/features/home/domain/usecases/unsave_paper_usecase.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/chatbot/presentation/cubit/chatbot_cubit.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_manager.dart';
import '../core/services/image_picker_service.dart';
import '../core/services/local_storage_service.dart';
import '../core/services/secure_storage_service.dart';
import '../core/services/user_cache_service.dart';
// Auth importss
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
import '../features/users/domain/usecases/get_user_profile_header_usecase.dart';
import '../features/users/domain/usecases/setup_profile_usecase.dart';
import '../features/users/domain/usecases/unfollow_user_usecase.dart';
import '../features/users/presentation/cubit/set_up_profile_cubit.dart';
import '../features/users/presentation/cubit/profile_header_cubit.dart';

final sl = GetIt.instance;

class DI {
  static Future<void> init() async {
    /// Dio ///
    sl.registerLazySingleton<Dio>(() => Dio());

    /// Secure Storage (must be registered before DioClient) ///
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    /// DioClient ///
    final dioClient = DioClient(
      dio: sl<Dio>(),
      secureStorage: sl<SecureStorageService>(),
    );
    await dioClient.init();
    sl.registerSingleton<DioClient>(dioClient);

    sl.registerLazySingleton(() => NetworkManager.instance..initialize());

    /// Local Storage ///
    final localStorage = await LocalStorageService.init();
    sl.registerLazySingleton<LocalStorageService>(() => localStorage);

    /// User Cache Service ///
    sl.registerLazySingleton<UserCacheService>(() => UserCacheService(sl()));

    /// Image Picker Service ///
    sl.registerLazySingleton<ImagePickerService>(() => ImagePickerService());

    //** Features **//

    //================ Authentication ========================

    /// Auth Data Sources ///
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dioClient: sl()),
    );

    ///   Auth Repository ///
    ///
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        secureStorage: sl(),
        localStorage: sl(),
        userCache: sl(),
      ),
    );

    // sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepositoryImpl());

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

    //================ Community ========================

    /// Community Data Sources ///
    sl.registerLazySingleton<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Community Repository ///
    sl.registerLazySingleton<CommunityRepository>(
      () => CommunityRepositoryImpl(remoteDataSource: sl()),
    );

    /// Community UseCases ///
    sl.registerLazySingleton(() => CreateDiscussionUseCase(sl()));
    sl.registerLazySingleton(() => GetAllDiscussionsUseCase(sl()));
    sl.registerLazySingleton(() => GetDiscussionByIdUseCase(sl()));
    sl.registerLazySingleton(() => DeleteDiscussionUseCase(sl()));
    sl.registerLazySingleton(() => VoteOnDiscussionUseCase(sl()));
    sl.registerLazySingleton(() => DeleteDiscussionVoteUseCase(sl()));
    sl.registerLazySingleton(() => CreateCommentUseCase(sl()));
    sl.registerLazySingleton(() => GetDiscussionCommentsUseCase(sl()));
    sl.registerLazySingleton(() => VoteOnCommentUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCommentVoteUseCase(sl()));

    /// Community Cubit ///
    sl.registerFactory(
      () => CommunityCubit(
        getAllDiscussionsUseCase: sl(),
        voteOnDiscussionUseCase: sl(),
      ),
    );
    sl.registerFactory(
      () => DiscussionDetailsCubit(
        getDiscussionByIdUseCase: sl(),
        getDiscussionCommentsUseCase: sl(),
        createCommentUseCase: sl(),
        voteOnCommentUseCase: sl(),
        voteOnDiscussionUseCase: sl(),
        userCacheService: sl(),
      ),
    );

    //================ Reading Lists ========================

    /// Reading List Data Sources ///
    sl.registerLazySingleton<ReadingListRemoteDataSource>(
      () => ReadingListRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Reading List Repository ///
    sl.registerLazySingleton<ReadingListRepository>(
      () => ReadingListRepositoryImpl(remoteDataSource: sl()),
    );

    /// Reading List UseCases ///
    sl.registerLazySingleton(() => GetReadingListsUseCase(sl()));
    sl.registerLazySingleton(() => CreateReadingListUseCase(sl()));
    sl.registerLazySingleton(() => GetReadingListByIdUseCase(sl()));
    sl.registerLazySingleton(() => AddPaperToListUseCase(sl()));
    sl.registerLazySingleton(() => RemovePaperFromListUseCase(sl()));

    /// Reading List Cubit ///
    sl.registerFactory(
      () => ReadingListCubit(
        getReadingListsUseCase: sl(),
        createReadingListUseCase: sl(),
        getReadingListByIdUseCase: sl(),
        addPaperToListUseCase: sl(),
        removePaperFromListUseCase: sl(),
      ),
    );

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
    sl.registerLazySingleton(() => GetUserProfileHeaderUsecase(sl()));
    sl.registerLazySingleton(() => FollowUserUsecase(sl()));
    sl.registerLazySingleton(() => UnfollowUserUsecase(sl()));

    /// Users Cubits ///
    sl.registerFactory(
      () => ProfileHeaderCubit(getUserProfileHeaderUsecase: sl()),
    );
    sl.registerFactory(() => SetUpProfileCubit(imagePickerService: sl()));

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
    sl.registerLazySingleton(() => SavePaperUseCase(repository: sl()));
    sl.registerLazySingleton(() => UnsavePaperUseCase(repository: sl()));

    /// Home Cubit ///
    sl.registerFactory(
      () => HomeCubit(
        getRecentPapersUseCase: sl(),
        getRecommendationsUseCase: sl(),
        getCurrentUserUsecase: sl(),
        savePaperUseCase: sl(),
        unsavePaperUseCase: sl(),
      ),
    );

    /// Chatbot Cubit ///
    sl.registerFactory(() => ChatbotCubit());
  }
}
