import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class ReplaceResearchInterestUsecase
    extends
        UseCase<
          List<ResearchInterestsEntitiy>,
          List<ResearchInterestsEntitiy>
        > {
  final SettingsRepository repository;

  ReplaceResearchInterestUsecase(this.repository);

  @override
  Future<Either<Failure, List<ResearchInterestsEntitiy>>> call(
    List<ResearchInterestsEntitiy> params,
  ) async {
    return await repository.replaceResearchInterests(interests: params);
  }
}
