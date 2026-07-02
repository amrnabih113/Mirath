// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class ChangeEmailUsecase extends UseCase<void, String> {
  final SettingsRepository repository;
  ChangeEmailUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.changeEmail(newEmail: params);
  }
}
