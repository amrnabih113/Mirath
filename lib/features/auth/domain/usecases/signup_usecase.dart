import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/signup_data.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<void, SignupData> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignupData params) async {
    return await repository.signUp(params);
  }
}
