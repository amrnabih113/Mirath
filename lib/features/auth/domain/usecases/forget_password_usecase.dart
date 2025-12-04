import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgetPasswordUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.forgetPassword(params);
  }
}
