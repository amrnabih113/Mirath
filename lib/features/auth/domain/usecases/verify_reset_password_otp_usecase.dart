import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/auth/domain/repositories/auth_repository.dart';

class VerifyResetPasswordOTPUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  VerifyResetPasswordOTPUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String otp) async {
    return await repository.verifyResetPasswordOTP(otp);
  }
}
