import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/users/domain/repositories/users_repository.dart';

class GetFollowingUsecase implements UseCase<void, String> {
  final UsersRepository usersRepository;

  GetFollowingUsecase({required this.usersRepository});
  @override
  Future<Either<Failure, dynamic>> call(String params) {
    return usersRepository.getFollowing(params);
  }
}
