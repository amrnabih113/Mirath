import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/chatbot_repository.dart';

class CreateTemporarySessionUseCase implements UseCase<Session, NoParams> {
  final ChatbotRepository repository;

  CreateTemporarySessionUseCase(this.repository);

  @override
  Future<Either<Failure, Session>> call(NoParams params) async {
    return await repository.createTemporarySession();
  }
}
