import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/update_profile_data.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class UpdateProfileUsecase implements UseCase<User, UpdateProfileData> {
  final UsersRepository repository;

  UpdateProfileUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileData params) async {
    return await repository.updateProfile(params);
  }
}
