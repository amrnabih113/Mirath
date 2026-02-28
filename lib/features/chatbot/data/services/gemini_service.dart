import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/entities/chat_message.dart';

class GeminiService {
  final String apiKey;
  final String modelName;

  GeminiService({required this.apiKey, this.modelName = 'gemini-1.5-flash'})
    : _model = GenerativeModel(model: modelName, apiKey: apiKey);

  final GenerativeModel _model;

  Future<String> generateReply({
    required List<ChatMessage> history,
    required String prompt,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY');
    }
    final buffer = StringBuffer();

    for (final message in history) {
      final role = message.isUser ? 'User' : 'Assistant';
      buffer.writeln('$role: ${message.text}');
    }

    buffer.writeln('User: $prompt');
    buffer.writeln('Assistant:');

    final response = await _model.generateContent([
      Content.text(buffer.toString()),
    ]);

    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      return 'Sorry, I could not generate a response.';
    }

    return text;
  }
}
