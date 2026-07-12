import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class GetPrivacySettingsUsecase
    extends UseCase<PrivacySettingsEntitiy, NoParams> {
  final SettingsRepository repository;

  GetPrivacySettingsUsecase(this.repository);

  @override
  Future<Either<Failure, PrivacySettingsEntitiy>> call(NoParams params) async {
    return await repository.getPrivacySettings();
  }
}
