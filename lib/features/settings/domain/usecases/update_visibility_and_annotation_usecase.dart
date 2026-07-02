import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class UpdateVisibilityAndAnnotationUsecase
    extends
        UseCase<ReadingAndAppearanceEntitiy, Tuple2<Visible, List<String>>> {
  final SettingsRepository repository;
    
  UpdateVisibilityAndAnnotationUsecase(this.repository);

  @override
  Future<Either<Failure, ReadingAndAppearanceEntitiy>> call(
    Tuple2<Visible, List<String>> params,
  ) async {
    return await repository
        .updateReadingListVisibilityandAnnotationColorPalette(
          defaultReadingListVisibility: params.value1,
          annotationHighlightColors: params.value2,
        );
  }
}
