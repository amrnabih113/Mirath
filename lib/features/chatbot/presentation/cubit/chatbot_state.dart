import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

sealed class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessage> messages;

  const ChatbotLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatbotMessageSending extends ChatbotState {
  final List<ChatMessage> messages;

  const ChatbotMessageSending({required this.messages});

  @override
  List<Object?> get props => [messages];
}
