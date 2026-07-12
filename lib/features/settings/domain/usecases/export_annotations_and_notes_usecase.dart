import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class ExportAnnotationsAndNotesUsecase
    extends UseCase<void, ExportAnnotationsFormate> {
  final SettingsRepository repository;

  ExportAnnotationsAndNotesUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(ExportAnnotationsFormate params) async {
    return await repository.exportAnnotationsAndNotes(formate: params);
  }
}
