import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/auth/domain/entities/signup_data.dart';
import 'package:mirath/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<void, SignupData> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignupData params) async {
    return await repository.signUp(params);
  }
}
