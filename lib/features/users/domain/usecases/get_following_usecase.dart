import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/follows.dart';
import '../repositories/users_repository.dart';

class GetFollowingUsecase implements UseCase<List<Follows>, String> {
  final UsersRepository usersRepository;

  GetFollowingUsecase({required this.usersRepository});
  @override
  Future<Either<Failure, List<Follows>>> call(String params) {
    return usersRepository.getFollowing(params);
  }
}
