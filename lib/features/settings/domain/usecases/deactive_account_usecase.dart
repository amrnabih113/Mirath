import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class DeactiveAccountUsecase extends UseCase<void, String> {
  final SettingsRepository repository;

  DeactiveAccountUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String password) async {
    return await repository.deactivateUserAccount(password: password);
  }
}
