import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mirath/core/cache/cache_keys.dart';
import 'package:mirath/core/cache/hive_cache_service.dart';
import 'package:mirath/core/services/local_storage_service.dart';
import 'package:mirath/core/services/user_cache_service.dart';
import 'package:mirath/core/utils/my_constants.dart';
import 'package:mirath/features/auth/data/models/auth_user_data.dart';
import 'package:mirath/features/users/data/models/user_model.dart';
import 'package:mirath/features/users/domain/entities/follows.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/profile_setup_data.dart';
import '../../domain/entities/update_profile_data.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../data_sources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  final NetworkManager networkManager;
  final UserCacheService userCacheService;
  final LocalStorageService localStorageService;
  final HiveCacheService cacheService;

  const UsersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkManager,
    required this.userCacheService,
    required this.localStorageService,
    required this.cacheService,
  });

  @override
  Future<Either<Failure, User>> setupProfile(
    ProfileSetupData profileSetupData,
  ) async {
    try {
      MyLogger.info('[UsersRepository] Setting up profile...');

      if (await networkManager.isConnected) {
        final result = await remoteDataSource.setupProfile(profileSetupData);
        await cacheCurrentUser(result.data);
        MyLogger.info('[UsersRepository] Profile setup successful');
        return Right(result.data);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Profile setup DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Profile setup unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      MyLogger.info('[UsersRepository] Getting current user...');

      if (await networkManager.isConnected) {
        final result = await remoteDataSource.getCurrentUser();
        await cacheCurrentUser(result.data);
        MyLogger.info('[UsersRepository] Get current user successful');
        return Right(result.data);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Get current user DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Get current user unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<User?> getCachedCurrentUser() async {
    final cached = await cacheService.getJson(
      CacheKeys.profile('current-user'),
      allowStale: true,
    );
    if (cached == null) {
      return null;
    }

    return UserModel.fromJson(cached);
  }

  @override
  Future<void> cacheCurrentUser(User user) async {
    await cacheService.putJson(
      CacheKeys.profile('current-user'),
      user.toJson(),
    );
  }

  @override
  Future<Either<Failure, User>> updateProfile(
    UpdateProfileData updateProfileData,
  ) async {
    try {
      MyLogger.info('[UsersRepository] Updating user profile...');

      if (await networkManager.isConnected) {
        final result = await remoteDataSource.updateProfile(updateProfileData);
        userCacheService.clearUser();
        final user = result.data;

        localStorageService.removeData(MyConstants.userDataKey);
        final jsonString = jsonEncode(user.toJson());
        await localStorageService.setData(MyConstants.userDataKey, jsonString);
        userCacheService.saveUser(
          AuthUserData(
            id: user.id,
            email: user.email,
            username: user.username,
            fullName: user.fullName,
            status: user.status,
          ),
        );
        await cacheCurrentUser(user);
        MyLogger.info('[UsersRepository] Profile update successful');

        return Right(result.data);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Update profile DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Update profile unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfileHeader(String userId) async {
    try {
      MyLogger.info('[UsersRepository] Getting user profile header: $userId');

      if (await networkManager.isConnected) {
        final result = await remoteDataSource.getUserProfileHeader(userId);
        await cacheUserProfileHeader(result.profile);
        MyLogger.info('[UsersRepository] Get user profile header successful');
        return Right(result.profile);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error(
        '[UsersRepository] Get user profile header DioException: $error',
      );
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Get user profile header unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<User?> getCachedUserProfileHeader(String userId) async {
    final cached = await cacheService.getJson(
      CacheKeys.profile(userId),
      allowStale: true,
    );
    if (cached == null) {
      return null;
    }

    return UserModel.fromJson(cached);
  }

  @override
  Future<void> cacheUserProfileHeader(User user) async {
    await cacheService.putJson(CacheKeys.profile(user.id), user.toJson());
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      MyLogger.info('[UsersRepository] Following user: $userId');

      if (await networkManager.isConnected) {
        await remoteDataSource.followUser(userId);
        await updateCachedFollowState(userId: userId, isFollowing: true);
        MyLogger.info('[UsersRepository] Follow user successful');
        return const Right(null);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Follow user DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error('[UsersRepository] Follow user unexpected error: $error');
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      MyLogger.info('[UsersRepository] Unfollowing user: $userId');

      if (await networkManager.isConnected) {
        await remoteDataSource.unfollowUser(userId);
        await updateCachedFollowState(userId: userId, isFollowing: false);
        MyLogger.info('[UsersRepository] Unfollow user successful');
        return const Right(null);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Unfollow user DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Unfollow user unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<void> updateCachedFollowState({
    required String userId,
    required bool isFollowing,
  }) async {
    Map<String, dynamic> transform(Map<String, dynamic> current) {
      current['isFollowing'] = isFollowing;
      current['isFollowed'] = isFollowing;
      return current;
    }

    await cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.profilePrefix,
      itemId: userId,
      idField: 'id',
      updater: transform,
    );
  }

  @override
  Future<Either<Failure, List<Follows>>> getFollowers(String id) async {
    try {
      MyLogger.info('[UsersRepository] Setting up profile...');

      if (await networkManager.isConnected) {
        final response = await remoteDataSource.getUserFollowers(id);
        MyLogger.info('[UsersRepository] Profile setup successful');
        return Right(response);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Profile setup DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Profile setup unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Follows>>> getFollowing(String id) async {
    try {
      MyLogger.info('[UsersRepository] Setting up profile...');

      if (await networkManager.isConnected) {
        final response = await remoteDataSource.getUserFollowing(id);
        MyLogger.info('[UsersRepository] Profile setup successful');
        return Right(response);
      } else {
        MyLogger.error('[UsersRepository] No internet connection');
        return const Left(NetworkFailure());
      }
    } on DioException catch (error) {
      MyLogger.error('[UsersRepository] Profile setup DioException: $error');
      return Left(mapExceptionToFailure(error));
    } catch (error) {
      MyLogger.error(
        '[UsersRepository] Profile setup unexpected error: $error',
      );
      return Left(UnexpectedFailure(error.toString()));
    }
  }
}
