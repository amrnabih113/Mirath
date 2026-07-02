import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class UpdateFeedAiPreferenceUsecase
    extends UseCase<FeedAndAiPreferenceEntity, FeedAndAiPreferenceEntity> {
  final SettingsRepository repository;

  UpdateFeedAiPreferenceUsecase(this.repository);

  @override
  Future<Either<Failure, FeedAndAiPreferenceEntity>> call(
    FeedAndAiPreferenceEntity params,
  ) async {
    return await repository.updateFeedAndAiPreference(preferences: params);
  }
}
