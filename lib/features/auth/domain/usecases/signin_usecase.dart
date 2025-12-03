import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/signin_data.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<void, SigninData> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SigninData params) async {
    return await repository.signIn(params);
  }
}
