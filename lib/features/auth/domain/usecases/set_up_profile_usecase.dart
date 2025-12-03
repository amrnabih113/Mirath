import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SetUpProfileUseCase implements UseCase<void, UserProfile> {
  final AuthRepository repository;

  SetUpProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UserProfile params) async {
    return await repository.setUpProfile(params);
  }
}
