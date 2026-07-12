import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/entities/all_active_session_entity.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class GetAllActiveSessionUsecase
    extends UseCase<List<AllActiveSessionEntity>, NoParams> {
  final SettingsRepository repository;

  GetAllActiveSessionUsecase(this.repository);
  @override
  Future<Either<Failure, List<AllActiveSessionEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getAllActiveSession();
  }
}
