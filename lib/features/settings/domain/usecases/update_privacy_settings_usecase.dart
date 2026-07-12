import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class UpdatePrivacySettingsUsecase
    extends UseCase<PrivacySettingsEntitiy, PrivacySettingsEntitiy> {
  final SettingsRepository repository;

  UpdatePrivacySettingsUsecase(this.repository);
  @override
  Future<Either<Failure, PrivacySettingsEntitiy>> call(
    PrivacySettingsEntitiy params,
  ) async {
    return await repository.updatePrivacySettings(settings: params);
  }
}
