import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chatbot_repository.dart';

class GetSessionMessagesUseCase implements UseCase<List<ChatMessage>, String> {
  final ChatbotRepository repository;

  GetSessionMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(String params) async {
    return await repository.getSessionMessages(params);
  }
}
