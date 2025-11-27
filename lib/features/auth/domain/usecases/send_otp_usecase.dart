import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/auth/domain/repositories/auth_repository.dart';

class SendOTPUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SendOTPUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.sendOTP();
  }
}
