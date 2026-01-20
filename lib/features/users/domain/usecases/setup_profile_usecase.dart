import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_setup_data.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class SetupProfileUsecase implements UseCase<User, ProfileSetupData> {
  final UsersRepository repository;

  SetupProfileUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(ProfileSetupData params) async {
    return await repository.setupProfile(params);
  }
}
