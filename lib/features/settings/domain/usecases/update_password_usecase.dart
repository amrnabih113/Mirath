import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class UpdatePasswordUsecase
    extends UseCase<void, Tuple3<String, String, String>> {
  final SettingsRepository repository;

  UpdatePasswordUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    Tuple3<String, String, String> params,
  ) async {
    return await repository.updatePassword(
      currentPassword: params.value1,
      newPassword: params.value2,
      confirmNewPassword: params.value3,
    );
  }
}
