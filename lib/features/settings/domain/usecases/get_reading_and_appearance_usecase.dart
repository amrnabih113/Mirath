import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class GetReadingAndAppearanceUsecase
    extends UseCase<ReadingAndAppearanceEntitiy, NoParams> {
  final SettingsRepository repository;

  GetReadingAndAppearanceUsecase(this.repository);

  @override
  Future<Either<Failure, ReadingAndAppearanceEntitiy>> call(
    NoParams params,
  ) async {
    return await repository.getReadingAndAppearance();
  }
}
