import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class ExportReadingListAsFileUsecase extends UseCase<void, ExportListFormate> {
  final SettingsRepository repository;

  ExportReadingListAsFileUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(ExportListFormate params) async {
    return await repository.exportReadingListsAsAFile(formate: params);
  }
}
