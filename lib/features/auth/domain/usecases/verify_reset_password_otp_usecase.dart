import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyResetPasswordOTPUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  VerifyResetPasswordOTPUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String otp) async {
    return await repository.verifyResetPasswordOTP(otp);
  }
}
