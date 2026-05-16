import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mirath/features/library/data/data_sources/library_data_sources.dart';
import 'package:mirath/features/library/data/data_sources/library_data_sources_impl.dart';
import 'package:mirath/features/library/data/repositories/library_repository_impl.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';
import 'package:mirath/features/library/domain/usecases/clear_all_reading_history.dart';
import 'package:mirath/features/library/domain/usecases/get_all_saved_papers.dart';
import 'package:mirath/features/library/domain/usecases/get_library_data.dart';
import 'package:mirath/features/library/domain/usecases/get_reading_history.dart';
import 'package:mirath/features/library/domain/usecases/remove_paper_from_reading_history.dart';
import 'package:mirath/features/library/domain/usecases/update_reading_history.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';
import 'package:mirath/features/Layout/presentation/cubit/layout_cubit.dart';
import 'package:mirath/features/reading_lists/domain/usecases/delete_reading_list_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/reading_list_cache_usecases.dart';
import 'package:mirath/features/reading_lists/domain/usecases/save_reading_list_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/unsave_reading_list_usecase.dart';
import 'package:mirath/features/reading_lists/domain/usecases/update_reading_list_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:mirath/features/auth/data/repositories/fake_auth_repository_impl.dart';
import 'package:mirath/features/discussions/data/data_sources/community_remote_data_source.dart';
import 'package:mirath/features/discussions/data/data_sources/community_remote_data_source_impl.dart';
import 'package:mirath/features/discussions/data/repositories/community_repository_impl.dart';
import 'package:mirath/features/discussions/domain/repositories/community_repository.dart';
import 'package:mirath/features/discussions/domain/usecases/create_comment_usecase.dart';
import 'package:mirath/features/discussions/domain/entities/create_comment_params.dart';
import 'package:mirath/features/discussions/domain/usecases/create_discussion_usecase.dart';
import 'package:mirath/features/discussions/domain/entities/create_discussion_params.dart';
import 'package:mirath/features/discussions/domain/usecases/community_cache_usecases.dart';
import 'package:mirath/features/discussions/domain/usecases/delete_comment_vote_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/delete_discussion_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/delete_discussion_vote_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/get_all_discussions_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/get_discussion_by_id_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/get_discussion_comments_usecase.dart';
import 'package:mirath/features/discussions/domain/usecases/vote_on_comment_usecase.dart';
import 'package:mirath/features/discussions/domain/entities/vote_params.dart';
import 'package:mirath/features/discussions/domain/usecases/vote_on_discussion_usecase.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_cubit.dart';
import 'package:mirath/features/discussions/presentation/cubit/discussion_details_cubit.dart';
import 'package:mirath/features/discussions/presentation/cubit/global_search_cubit.dart';
import '../features/home/domain/usecases/get_paper_categories_usecase.dart';
import '../features/home/domain/usecases/home_cache_usecases.dart';
import 'package:mirath/features/paper_annotations/data/data_sources/annotation_local_data_source.dart';
import 'package:mirath/features/paper_annotations/data/data_sources/annotation_local_data_source_impl.dart';
import 'package:mirath/features/paper_annotations/data/data_sources/annotation_remote_data_source.dart';
import 'package:mirath/features/paper_annotations/data/data_sources/annotation_remote_data_source_impl.dart';
import 'package:mirath/features/paper_annotations/data/repositories/annotation_repository_impl.dart';
import 'package:mirath/features/paper_annotations/domain/repositories/annotation_repository.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/add_highlight_note_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/delete_highlight_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/delete_highlight_note_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/get_annotated_highlights_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/get_highlights_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/save_highlight_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/update_highlight_note_usecase.dart';
import 'package:mirath/features/paper_annotations/domain/usecases/update_highlight_usecase.dart';
import 'package:mirath/features/paper_annotations/presentation/cubit/paper_reading_cubit.dart';
import 'package:mirath/features/papers/data/data_sources/paper_remote_data_source.dart';
import 'package:mirath/features/papers/data/repository/paper_repository_impl.dart';
import 'package:mirath/features/papers/domain/repository/paper_repository.dart';
import 'package:mirath/features/papers/domain/usecases/get_paper_by_id_usecase.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/data/data_sources/reading_list_remote_data_source.dart';
import 'package:mirath/features/reading_lists/data/data_sources/reading_list_remote_data_source_impl.dart';
import 'package:mirath/features/reading_lists/data/repositories/reading_list_repository_impl.dart';
import 'package:mirath/features/users/domain/usecases/update_profile_usecase.dart';
import 'package:mirath/features/profile/presentation/cubit/profile_cubit.dart';
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
import 'package:mirath/features/home/domain/usecases/get_search_history_usecase.dart';
import 'package:mirath/features/home/domain/usecases/delete_search_history_usecase.dart';
import 'package:mirath/features/home/domain/usecases/clear_search_history_usecase.dart';
import 'package:mirath/features/home/domain/usecases/search_discussions_usecase.dart';
import 'package:mirath/features/home/domain/usecases/search_global_usecase.dart';
import 'package:mirath/features/home/domain/usecases/search_reading_lists_usecase.dart';
import 'package:mirath/features/home/domain/usecases/search_researchers_usecase.dart';
import 'package:mirath/features/home/domain/usecases/search_papers_usecase.dart';
import 'package:mirath/features/home/domain/usecases/save_paper_usecase.dart';
import 'package:mirath/features/home/domain/usecases/unsave_paper_usecase.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/home/presentation/cubit/search_cubit.dart';
import 'package:mirath/features/chatbot/presentation/cubit/chatbot_cubit.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_manager.dart';
import '../core/cache/hive_cache_service.dart';
import '../core/cache/cache_keys.dart';
import 'package:mirath/features/discussions/data/models/comment_model.dart';
import 'package:mirath/core/sync/retry_queue.dart';
import '../core/services/image_picker_service.dart';
import '../core/services/local_storage_service.dart';
import '../core/services/secure_storage_service.dart';
import '../core/services/user_cache_service.dart';
import '../core/sync/hive_retry_queue.dart';
import '../core/sync/sync_manager.dart';
import '../core/sync/retry_service.dart';
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
import '../features/users/domain/usecases/get_followers_usecase.dart';
import '../features/users/domain/usecases/get_following_usecase.dart';
import '../features/users/domain/usecases/get_current_user_usecase.dart';
import '../features/users/domain/usecases/get_user_profile_header_usecase.dart';
import '../features/users/domain/usecases/setup_profile_usecase.dart';
import '../features/users/domain/usecases/unfollow_user_usecase.dart';
import '../features/users/domain/usecases/users_cache_usecases.dart';
import '../features/users/presentation/cubit/profile_header_cubit.dart';
import '../features/users/presentation/cubit/set_up_profile_cubit.dart';

final sl = GetIt.instance;

class DI {
  static Future<void> init() async {
    /// Dio ///
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
    );

    /// Secure Storage (must be registered before DioClient) ///
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    /// DioClient ///
    final dioClient = DioClient(
      dio: sl<Dio>(),
      secureStorage: sl<SecureStorageService>(),
      onAuthFailure: () => sl<AuthCubit>().signOut(),
    );
    await dioClient.init();
    sl.registerSingleton<DioClient>(dioClient);

    sl.registerLazySingleton(() => NetworkManager.instance..initialize());

    /// Local Storage ///
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    final localStorage = await LocalStorageService.init();
    sl.registerLazySingleton<LocalStorageService>(() => localStorage);

    final hiveCacheService = await HiveCacheService.init();
    sl.registerLazySingleton<HiveCacheService>(() => hiveCacheService);

    // Retry queue (persistent)
    sl.registerLazySingleton<RetryQueue>(
      () => HiveRetryQueue(cacheService: sl()),
    );

    // Retry service helper
    sl.registerLazySingleton(() => RetryService(sl()));

    // Sync manager
    sl.registerLazySingleton<SyncManager>(
      () => SyncManager(retryQueue: sl())..start(),
    );

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
        cacheService: sl(),
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
        getCurrentUserUsecase: sl(),
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
      () => CommunityRepositoryImpl(remoteDataSource: sl(), cacheService: sl()),
    );

    /// Community UseCases ///
    sl.registerLazySingleton(() => CreateDiscussionUseCase(sl()));
    // Register sync handler for queued discussion creations
    // (SyncManager is already registered above; fetch and register handler)
    sl<SyncManager>().registerHandler('create_discussion', (payload) async {
      try {
        final title = payload['title'] as String? ?? '';
        final content = payload['content'] as String? ?? '';
        final topics =
            (payload['topicIds'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];
        final paperIds = (payload['paperIds'] as List?)
            ?.map((e) => e.toString())
            .toList();
        final params = CreateDiscussionParams(
          title: title,
          content: content,
          topicIds: topics,
          paperIds: paperIds,
        );
        final result = await sl<CreateDiscussionUseCase>()(params);
        result.fold(
          (_) {
            // failure will be retried
            throw Exception('create_discussion failed');
          },
          (discussion) async {
            // repository already upserts the server discussion; remove local draft if present
            final clientId = payload['clientId'] as String?;
            if (clientId != null && clientId.isNotEmpty) {
              await sl<CommunityRepository>().removeCachedDiscussion(clientId);
            }
          },
        );
      } catch (_) {
        rethrow; // let SyncManager retry later
      }
    });
    // Other queued operation handlers
    sl<SyncManager>().registerHandler('create_comment', (payload) async {
      try {
        final discussionId = payload['discussionId']?.toString() ?? '';
        final content = payload['content']?.toString() ?? '';
        final parentId = payload['parentId']?.toString();
        final clientId = payload['clientId']?.toString();

        final result = await sl<CreateCommentUseCase>()(
          CreateCommentParams(
            discussionId: discussionId,
            content: content,
            parentId: parentId,
          ),
        );

        result.fold(
          (failure) {
            throw Exception('create_comment failed');
          },
          (comment) async {
            // Try to convert to model json; CommentModel has toJson()
            Map<String, dynamic> json;
            if (comment is CommentModel) {
              json = comment.toJson();
            } else {
              // Fallback minimal mapping
              json = {
                'id': comment.id,
                'content': comment.content,
                'upvoteCount': comment.upvoteCount,
                'downvoteCount': comment.downvoteCount,
                'authorId': comment.authorId,
                'discussionId': comment.discussionId,
                'parentId': comment.parentId,
                'createdAt': comment.createdAt.toIso8601String(),
                'updatedAt': comment.updatedAt.toIso8601String(),
                'hasVoted': comment.hasVoted,
                'userVoteType': comment.userVoteType,
                'author': {
                  'id': comment.author.id,
                  'username': comment.author.username,
                  'fullName': comment.author.fullName,
                  'photoUrl': comment.author.photoUrl,
                },
              };
            }

            // Persist server comment and update discussion comment list
            await sl<HiveCacheService>().putJson(
              CacheKeys.commentById(json['id'].toString()),
              json,
            );
            await sl<HiveCacheService>().upsertInJsonList(
              key: CacheKeys.comments(discussionId),
              item: json,
              idField: 'id',
            );

            // Remove local draft if present
            if (clientId != null && clientId.isNotEmpty) {
              await sl<HiveCacheService>().remove(
                CacheKeys.commentById(clientId),
              );
              await sl<HiveCacheService>().removeFromJsonList(
                key: CacheKeys.comments(discussionId),
                itemId: clientId,
                idField: 'id',
              );
            }
          },
        );
      } catch (_) {
        rethrow;
      }
    });

    sl<SyncManager>().registerHandler('vote_discussion', (payload) async {
      try {
        final discussionId = payload['discussionId']?.toString() ?? '';
        final upvote = payload['upvote'] as bool? ?? true;
        final params = VoteParams(
          id: discussionId,
          type: upvote ? 'up' : 'down',
        );
        await sl<VoteOnDiscussionUseCase>()(params);
      } catch (_) {
        rethrow;
      }
    });

    sl<SyncManager>().registerHandler('vote_comment', (payload) async {
      try {
        final commentId = payload['commentId']?.toString() ?? '';
        final upvote = payload['upvote'] as bool? ?? true;
        final params = VoteParams(id: commentId, type: upvote ? 'up' : 'down');
        await sl<VoteOnCommentUseCase>()(params);
      } catch (_) {
        rethrow;
      }
    });

    sl<SyncManager>().registerHandler('save_paper', (payload) async {
      try {
        final paperId = payload['paperId']?.toString() ?? '';
        await sl<SavePaperUseCase>()(paperId);
      } catch (_) {
        rethrow;
      }
    });

    sl<SyncManager>().registerHandler('unsave_paper', (payload) async {
      try {
        final paperId = payload['paperId']?.toString() ?? '';
        await sl<UnsavePaperUseCase>()(paperId);
      } catch (_) {
        rethrow;
      }
    });

    sl<SyncManager>().registerHandler('delete_discussion', (payload) async {
      try {
        final id = payload['discussionId']?.toString() ?? '';
        await sl<DeleteDiscussionUseCase>()(id);
      } catch (_) {
        rethrow;
      }
    });

    // Messaging: send_message handler — posts to API and reconciles clientId
    sl<SyncManager>().registerHandler('send_message', (payload) async {
      try {
        final conversationId = payload['conversationId']?.toString() ?? '';
        final text = payload['text']?.toString() ?? '';
        final clientId = payload['clientId']?.toString();

        final body = {
          'conversationId': conversationId,
          'text': text,
          if (clientId != null) 'clientId': clientId,
        };

        final resp = await sl<DioClient>().post('/messages', data: body);
        final data = resp.data as Map<String, dynamic>;

        // Build server message and persist
        final serverMessage = data;
        // Upsert into message-by-id and conversation list
        await sl<HiveCacheService>().putJson(
          CacheKeys.messageById(serverMessage['id'].toString()),
          serverMessage,
        );
        await sl<HiveCacheService>().upsertInJsonList(
          key: CacheKeys.messages(conversationId),
          item: serverMessage,
          idField: 'id',
        );

        // Remove local draft if clientId provided
        if (clientId != null && clientId.isNotEmpty) {
          await sl<HiveCacheService>().remove(CacheKeys.messageById(clientId));
          await sl<HiveCacheService>().removeFromJsonList(
            key: CacheKeys.messages(conversationId),
            itemId: clientId,
            idField: 'id',
          );
        }
      } catch (_) {
        rethrow;
      }
    });

    sl.registerLazySingleton(() => GetAllDiscussionsUseCase(sl()));
    sl.registerLazySingleton(() => GetDiscussionByIdUseCase(sl()));
    sl.registerLazySingleton(() => DeleteDiscussionUseCase(sl()));
    sl.registerLazySingleton(() => VoteOnDiscussionUseCase(sl()));
    sl.registerLazySingleton(() => DeleteDiscussionVoteUseCase(sl()));
    sl.registerLazySingleton(() => CreateCommentUseCase(sl()));
    sl.registerLazySingleton(() => GetDiscussionCommentsUseCase(sl()));
    sl.registerLazySingleton(() => VoteOnCommentUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCommentVoteUseCase(sl()));
    sl.registerLazySingleton(() => CommunityCacheUseCases(repository: sl()));

    /// Community Cubit ///
    sl.registerFactory(
      () => CommunityCubit(
        communityCacheUseCases: sl(),
        getAllDiscussionsUseCase: sl(),
        voteOnDiscussionUseCase: sl(),
        deleteDiscussionVoteUseCase: sl(),
        followUserUsecase: sl(),
        unfollowUserUsecase: sl(),
      ),
    );
    sl.registerFactory(
      () => DiscussionDetailsCubit(
        getDiscussionByIdUseCase: sl(),
        getDiscussionCommentsUseCase: sl(),
        createCommentUseCase: sl(),
        voteOnCommentUseCase: sl(),
        voteOnDiscussionUseCase: sl(),
        deleteCommentVoteUseCase: sl(),
        deleteDiscussionVoteUseCase: sl(),
        userCacheService: sl(),
      ),
    );
    //================ Library ========================
    /// Library Data Sources ///
    sl.registerLazySingleton<LibraryDataSources>(
      () => LibraryDataSourcesImpl(dioClient: sl()),
    );

    /// Library Repository ///
    sl.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(libraryDataSources: sl(), cacheService: sl()),
    );

    /// Library UseCases ///
    sl.registerLazySingleton(() => GetLibraryData(libraryRepository: sl()));
    sl.registerLazySingleton(() => GetReadingHistory(libraryRepository: sl()));
    sl.registerLazySingleton(
      () => UpdateReadingHistory(libraryRepository: sl()),
    );
    sl.registerLazySingleton(
      () => ClearAllReadingHistory(libraryRepository: sl()),
    );
    sl.registerLazySingleton(() => GetAllSavedPapers(libraryRepository: sl()));
    sl.registerLazySingleton(
      () => RemovePaperFromReadingHistory(libraryRepository: sl()),
    );

    /// Library Cubit ///
    sl.registerFactory(
      () => LibraryCubit(
        getLibraryDataUseCase: sl(),
        getReadingHistoryUseCase: sl(),
        updateReadingHistoryUseCase: sl(),
        clearAllReadingHistoryUseCase: sl(),
        getAllSavedPapersUseCase: sl(),
        removePaperFromReadingHistoryUseCase: sl(),
        cacheService: sl(),
      ),
    );

    //================ Reading Lists ========================

    /// Reading List Data Sources ///
    sl.registerLazySingleton<ReadingListRemoteDataSource>(
      () => ReadingListRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Reading List Repository ///
    sl.registerLazySingleton<ReadingListRepository>(
      () =>
          ReadingListRepositoryImpl(remoteDataSource: sl(), cacheService: sl()),
    );

    /// Reading List UseCases ///
    sl.registerLazySingleton(() => GetReadingListsUseCase(sl()));
    sl.registerLazySingleton(() => CreateReadingListUseCase(sl()));
    sl.registerLazySingleton(() => GetReadingListByIdUseCase(sl()));
    sl.registerLazySingleton(() => AddPaperToListUseCase(sl()));
    sl.registerLazySingleton(() => RemovePaperFromListUseCase(sl()));
    sl.registerLazySingleton(() => SaveReadingListUseCase(sl()));
    sl.registerLazySingleton(() => UnsaveReadingListUseCase(sl()));
    sl.registerLazySingleton(() => UpdateReadingListUseCase(sl()));
    sl.registerLazySingleton(() => DeleteReadingListUseCase(sl()));
    sl.registerLazySingleton(() => ReadingListCacheUseCases(repository: sl()));

    /// Reading List Cubit ///
    sl.registerFactory(
      () => ReadingListCubit(
        readingListCacheUseCases: sl(),
        getReadingListsUseCase: sl(),
        createReadingListUseCase: sl(),
        getReadingListByIdUseCase: sl(),
        addPaperToListUseCase: sl(),
        removePaperFromListUseCase: sl(),
        saveReadingListUseCase: sl(),
        unsaveReadingListUseCase: sl(),
      ),
    );

    //================ Users ========================

    /// Users Data Sources ///
    sl.registerLazySingleton<UsersRemoteDataSource>(
      () => UsersRemoteDataSourceImpl(dioClient: sl()),
    );

    /// Users Repository ///
    sl.registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(
        remoteDataSource: sl(),
        networkManager: sl(),
        userCacheService: sl(),
        localStorageService: sl(),
        cacheService: sl(),
      ),
    );

    /// Users UseCases ///
    sl.registerLazySingleton(() => SetupProfileUsecase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
    sl.registerLazySingleton(() => UpdateProfileUsecase(sl()));
    sl.registerLazySingleton(() => GetUserProfileHeaderUsecase(sl()));
    sl.registerLazySingleton(() => FollowUserUsecase(sl()));
    sl.registerLazySingleton(() => UnfollowUserUsecase(sl()));
    sl.registerLazySingleton(() => GetFollowersUsecase(usersRepository: sl()));
    sl.registerLazySingleton(() => GetFollowingUsecase(usersRepository: sl()));
    sl.registerLazySingleton(() => UsersCacheUseCases(repository: sl()));

    /// Users Cubits ///
    sl.registerFactory(() => SetUpProfileCubit(imagePickerService: sl()));
    sl.registerLazySingleton(
      () => ProfileCubit(
        usersCacheUseCases: sl(),
        getCurrentUserUsecase: sl(),
        updateProfileUsecase: sl(),
      ),
    );
    sl.registerFactory(
      () => ProfileHeaderCubit(
        usersCacheUseCases: sl(),
        getUserProfileHeaderUsecase: sl(),
        followUserUsecase: sl(),
        unfollowUserUsecase: sl(),
      ),
    );

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
      () => HomeRepositoryImpl(
        remoteDataSource: sl(),
        networkManager: sl(),
        cacheService: sl(),
      ),
    );

    /// Home UseCases ///
    sl.registerLazySingleton(() => GetRecentPapersUseCase(repository: sl()));
    sl.registerLazySingleton(() => GetRecommendationsUseCase(repository: sl()));
    sl.registerLazySingleton(() => GetPaperCategoriesUseCase(repository: sl()));
    sl.registerLazySingleton(() => SavePaperUseCase(repository: sl()));
    sl.registerLazySingleton(() => UnsavePaperUseCase(repository: sl()));
    sl.registerLazySingleton(() => SearchPapersUseCase(repository: sl()));
    sl.registerLazySingleton(() => SearchGlobalUseCase(repository: sl()));
    sl.registerLazySingleton(() => SearchDiscussionsUseCase(repository: sl()));
    sl.registerLazySingleton(() => SearchReadingListsUseCase(repository: sl()));
    sl.registerLazySingleton(() => SearchResearchersUseCase(repository: sl()));
    sl.registerLazySingleton(() => GetSearchHistoryUseCase(repository: sl()));
    sl.registerLazySingleton(
      () => DeleteSearchHistoryUseCase(repository: sl()),
    );
    sl.registerLazySingleton(() => ClearSearchHistoryUseCase(repository: sl()));
    sl.registerLazySingleton(() => HomeCacheUseCases(repository: sl()));

    /// Home Cubit ///
    sl.registerLazySingleton(
      () => HomeCubit(
        homeCacheUseCases: sl(),
        getRecentPapersUseCase: sl(),
        getRecommendationsUseCase: sl(),
        getCurrentUserUsecase: sl(),
        getPaperCategoriesUseCase: sl(),
        savePaperUseCase: sl(),
        unsavePaperUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => SearchCubit(
        getSearchHistoryUseCase: sl(),
        deleteSearchHistoryUseCase: sl(),
        clearSearchHistoryUseCase: sl(),
        searchPapersUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => GlobalSearchCubit(
        searchGlobalUseCase: sl(),
        searchDiscussionsUseCase: sl(),
        searchReadingListsUseCase: sl(),
        searchResearchersUseCase: sl(),
      ),
    );

    /// Chatbot ///
    sl.registerFactory(() => ChatbotCubit());

    /// Layout Cubit ///
    sl.registerLazySingleton(() => LayoutCubit());

    /// papers ///
    // Data Sources
    sl.registerLazySingleton<PaperRemoteDataSource>(
      () => PaperRemoteDataSourceImpl(dioClient: sl()),
    );

    // Repository
    sl.registerLazySingleton<PaperRepository>(
      () => PaperRepositoryImpl(
        remoteDataSource: sl(),
        networkManager: sl(),
        cacheService: sl(),
      ),
    );

    // UseCases
    sl.registerLazySingleton(() => GetPaperByIdUseCase(sl()));

    /// Paper Annotations ///
    // Data Sources
    sl.registerLazySingleton<AnnotationLocalDataSource>(
      () => AnnotationLocalDataSourceImpl(sharedPreferences: sl()),
    );

    sl.registerLazySingleton<AnnotationRemoteDataSource>(
      () => AnnotationRemoteDataSourceImpl(dioClient: sl()),
    );

    // Repository
    sl.registerLazySingleton<AnnotationRepository>(
      () => AnnotationRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );

    // Use Cases
    sl.registerLazySingleton(() => GetHighlightsUseCase(sl()));
    sl.registerLazySingleton(() => GetAnnotatedHighlightsUseCase(sl()));
    sl.registerLazySingleton(() => SaveHighlightUseCase(sl()));
    sl.registerLazySingleton(() => UpdateHighlightUseCase(sl()));
    sl.registerLazySingleton(() => DeleteHighlightUseCase(sl()));
    sl.registerLazySingleton(() => AddHighlightNoteUseCase(sl()));
    sl.registerLazySingleton(() => UpdateHighlightNoteUseCase(sl()));
    sl.registerLazySingleton(() => DeleteHighlightNoteUseCase(sl()));

    // Cubit
    sl.registerFactory(
      () => PaperReadingCubit(
        getPaperByIdUseCase: sl(),
        getHighlightsUseCase: sl(),
        getAnnotatedHighlightsUseCase: sl(),
        saveHighlightUseCase: sl(),
        updateHighlightUseCase: sl(),
        deleteHighlightUseCase: sl(),
        addHighlightNoteUseCase: sl(),
        updateHighlightNoteUseCase: sl(),
        deleteHighlightNoteUseCase: sl(),
      ),
    );
  }
}
