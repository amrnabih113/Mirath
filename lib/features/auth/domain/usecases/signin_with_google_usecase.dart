import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signinWithGoogle();
  }
}
