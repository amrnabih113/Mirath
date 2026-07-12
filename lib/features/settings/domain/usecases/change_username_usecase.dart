import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class ChangeUsernameUsecase extends UseCase<String, String> {
  final SettingsRepository repository;

  ChangeUsernameUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.changeUsername(newUsername: params);
  }
}
