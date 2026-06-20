import '../../domain/repositories/chatbot_repository.dart';

class StreamMessagesUseCase {
  final ChatbotRepository repository;

  StreamMessagesUseCase(this.repository);

  Stream<String> call(
    String sessionId, {
    Map<String, String>? extraHeaders,
    Map<String, dynamic>? body,
  }) {
    return repository.streamMessages(
      sessionId,
      extraHeaders: extraHeaders,
      body: body,
    );
  }
}
