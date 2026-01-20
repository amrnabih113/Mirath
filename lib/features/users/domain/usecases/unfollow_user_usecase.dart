import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/users_repository.dart';

class UnfollowUserUsecase implements UseCase<void, String> {
  final UsersRepository repository;

  UnfollowUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.unfollowUser(params);
  }
}
