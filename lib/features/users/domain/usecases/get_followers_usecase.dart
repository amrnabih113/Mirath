import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/users/domain/entities/follows.dart';
import 'package:mirath/features/users/domain/repositories/users_repository.dart';

class GetFollowersUsecase implements UseCase<List<Follows>, String> {
  final UsersRepository usersRepository;

  GetFollowersUsecase({required this.usersRepository});
  @override
  Future<Either<Failure, List<Follows>>> call(String params) {
    return usersRepository.getFollowers(params);
  }
}
