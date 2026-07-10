import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class DisconnectGoogleAccountUsecase extends UseCase<String, NoParams> {
  final SettingsRepository repository;

  DisconnectGoogleAccountUsecase(this.repository);
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.disconnectGoogleAccount();
  }
}
