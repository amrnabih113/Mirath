import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class GetUserProfileHeaderUsecase implements UseCase<User, String> {
  final UsersRepository repository;

  GetUserProfileHeaderUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUserProfileHeader(userId);
  }
}
