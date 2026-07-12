import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/chatbot_repository.dart';

class GetSessionsUseCase implements UseCase<List<Session>, NoParams> {
  final ChatbotRepository repository;

  GetSessionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Session>>> call(NoParams params) async {
    return await repository.getSessions();
  }
}
