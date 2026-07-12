import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class GetFeedAiPreferenceUsecase
    extends UseCase<FeedAndAiPreferenceEntity, NoParams> {
  final SettingsRepository repository;

  GetFeedAiPreferenceUsecase(this.repository);
  @override
  Future<Either<Failure, FeedAndAiPreferenceEntity>> call(
    NoParams params,
  ) async {
    return await repository.getFeedAndAiPreference();
  }
}
