import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class RevokeAllActiveSessionExceptCurrentUsecase
    extends UseCase<void, NoParams> {
  final SettingsRepository repository;

  RevokeAllActiveSessionExceptCurrentUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.revokeAllActiveSessionExceptCurrent();
  }
}
