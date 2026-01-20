import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/users_repository.dart';

class FollowUserUsecase implements UseCase<void, String> {
  final UsersRepository repository;

  FollowUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.followUser(params);
  }
}
