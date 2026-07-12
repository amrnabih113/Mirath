import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class UpdateThemeFontDisplayPreferenceUsecase
    extends UseCase<ReadingAndAppearanceEntitiy, Tuple2<ColorMode, FontSize>> {
  final SettingsRepository repository;

  UpdateThemeFontDisplayPreferenceUsecase(this.repository);

  @override
  Future<Either<Failure, ReadingAndAppearanceEntitiy>> call(
    Tuple2<ColorMode, FontSize> params,
  ) async {
    return await repository.updatethemeAndDisplayPreferences(
      colorMode: params.value1,
      defaultFontSize: params.value2,
    );
  }
}
