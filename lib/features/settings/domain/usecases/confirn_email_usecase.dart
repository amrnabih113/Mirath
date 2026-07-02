import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class ConfirmEmailUsecase extends UseCase<void, Tuple2<String, String>> {
  final SettingsRepository repository;

  ConfirmEmailUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Tuple2<String, String> params) async {
    return await repository.confirmEmail(
      newEmail: params.value1,
      otpCode: params.value2,
    );
  }
}
