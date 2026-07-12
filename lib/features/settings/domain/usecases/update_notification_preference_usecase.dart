import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class UpdateNotificationPreferenceUsecase
    extends
        UseCase<NotificationPreferencesEntity, NotificationPreferencesEntity> {
  final SettingsRepository repository;

  UpdateNotificationPreferenceUsecase(this.repository);
  @override
  Future<Either<Failure, NotificationPreferencesEntity>> call(
    NotificationPreferencesEntity params,
  ) async {
    return await repository.updateNotificationPreferences(preferences: params);
  }
}
