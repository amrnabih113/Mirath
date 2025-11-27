import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/auth/domain/entities/signin_data.dart';
import 'package:mirath/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase implements UseCase<void, SigninData> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SigninData params) async {
    return await repository.signIn(params);
  }
}
