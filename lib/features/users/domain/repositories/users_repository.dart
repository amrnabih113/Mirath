import 'package:dartz/dartz.dart';
import 'package:mirath/features/users/domain/entities/follows.dart';

import '../../../../core/error/failuors.dart';
import '../entities/profile_setup_data.dart';
import '../entities/update_profile_data.dart';
import '../entities/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, User>> setupProfile(ProfileSetupData profileSetupData);
  Future<Either<Failure, User>> getCurrentUser();

  Future<User?> getCachedCurrentUser();

  Future<void> cacheCurrentUser(User user);

  Future<Either<Failure, User>> updateProfile(
    UpdateProfileData updateProfileData,
  );
  Future<Either<Failure, User>> getUserProfileHeader(String userId);

  Future<User?> getCachedUserProfileHeader(String userId);

  Future<void> cacheUserProfileHeader(User user);

  Future<void> updateCachedFollowState({
    required String userId,
    required bool isFollowing,
  });

  Future<Either<Failure, void>> followUser(String userId);
  Future<Either<Failure, void>> unfollowUser(String userId);
  Future<Either<Failure, List<Follows>>> getFollowers(String id);
  Future<Either<Failure, List<Follows>>> getFollowing(String id);
}
