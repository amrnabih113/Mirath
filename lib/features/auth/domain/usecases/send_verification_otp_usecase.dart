import 'package:dartz/dartz.dart';
import 'package:mirath/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';

class SendVerificationOTPUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SendVerificationOTPUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.sendVerificationOTP();
  }
}