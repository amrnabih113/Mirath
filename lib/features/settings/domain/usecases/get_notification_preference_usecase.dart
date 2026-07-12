import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class GetNotificationPreferenceUsecase
    extends UseCase<NotificationPreferencesEntity, NoParams> {
  final SettingsRepository repository;

  GetNotificationPreferenceUsecase(this.repository);
  @override
  Future<Either<Failure, NotificationPreferencesEntity>> call(
    NoParams params,
  ) async {
    return await repository.getNotificationPreferences();
  }
}
