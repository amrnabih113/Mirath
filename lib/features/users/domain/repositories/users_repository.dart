import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entities/profile_setup_data.dart';
import '../entities/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, User>> setupProfile(ProfileSetupData profileSetupData);
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> followUser(String userId);
  Future<Either<Failure, void>> unfollowUser(String userId);
}
