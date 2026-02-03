import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(const ChatbotInitial());

  final List<ChatMessage> _messages = [];

  void initialize() {
    _loadMockMessages();
    emit(ChatbotLoaded(messages: _messages));
  }

  void _loadMockMessages() {
    _messages.addAll([
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hello! How can I help you with your research today?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Can you help me understand neural networks?',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text:
            'Of course! Neural networks are computing systems inspired by biological neural networks. They consist of interconnected nodes (neurons) organized in layers that process and learn from data. Would you like me to explain a specific aspect?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Yes, can you explain backpropagation?',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text:
            'Backpropagation is the key algorithm for training neural networks. It works by:\n\n1. Computing the error at the output\n2. Propagating this error backward through the network\n3. Adjusting weights to minimize the error\n\nThis process uses gradient descent and the chain rule from calculus.',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ]);
  }

  void sendMessage(String text, {List<String>? imagePaths}) {
    if (text.trim().isEmpty && (imagePaths == null || imagePaths.isEmpty)) {
      return;
    }

    // Add user message
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      imagePaths: imagePaths,
    );

    _messages.add(userMessage);
    emit(ChatbotMessageSending(messages: List.from(_messages)));

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        text: 'I understand your question. Let me help you with that...',
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(aiMessage);
      emit(ChatbotLoaded(messages: List.from(_messages)));
    });
  }

  void removeImage(int index, List<String> imagePaths) {
    imagePaths.removeAt(index);
    emit(ChatbotLoaded(messages: List.from(_messages)));
  }
}
