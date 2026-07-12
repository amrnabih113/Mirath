import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/chatbot_repository.dart';

class GetSessionByIdUseCase implements UseCase<Session, String> {
  final ChatbotRepository repository;

  GetSessionByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Session>> call(String params) async {
    return await repository.getSessionById(params);
  }
}
