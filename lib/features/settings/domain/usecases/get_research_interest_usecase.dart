import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class GetResearchInterestUsecase extends UseCase<List<ResearchInterestsEntitiy>, NoParams> {
  final SettingsRepository repository;

  GetResearchInterestUsecase(this.repository);
  @override
  Future<Either<Failure, List<ResearchInterestsEntitiy>>> call(
    NoParams params,
  ) async {
    return await repository.getResearchInterests();
  }
}
