import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class DeleteAccountUsecase extends UseCase<String, String> {
  final SettingsRepository repository;

  DeleteAccountUsecase(this.repository);
  @override
  Future<Either<Failure, String>> call(String password) {
    return repository.deleteUserAccount(password: password);
  }
}
