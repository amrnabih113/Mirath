import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/send_message_params.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase
    implements UseCase<Map<String, dynamic>, SendMessageParams> {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    SendMessageParams params,
  ) async {
    return await repository.sendMessage(params.sessionId, params.body);
  }
}
