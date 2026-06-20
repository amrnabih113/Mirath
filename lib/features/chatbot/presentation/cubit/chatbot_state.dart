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
  final String? currentSessionId;
  final bool isTemporaryChat;

  const ChatbotLoaded({
    required this.messages,
    this.currentSessionId,
    this.isTemporaryChat = false,
  });

  @override
  List<Object?> get props => [messages, currentSessionId, isTemporaryChat];
}

class ChatbotError extends ChatbotState {
  final String message;
  final String? errorCode;
  final bool isRecoverable;

  const ChatbotError({
    required this.message,
    this.errorCode,
    this.isRecoverable = true,
  });

  @override
  List<Object?> get props => [message, errorCode, isRecoverable];
}

class ChatbotMessageSending extends ChatbotState {
  final List<ChatMessage> messages;
  final String? currentSessionId;
  final bool isTemporaryChat;

  const ChatbotMessageSending({
    required this.messages,
    this.currentSessionId,
    this.isTemporaryChat = false,
  });

  @override
  List<Object?> get props => [messages, currentSessionId, isTemporaryChat];
}

/// State when stream is actively sending response
class ChatbotMessageStreaming extends ChatbotState {
  final List<ChatMessage> messages;
  final String? currentSessionId;
  final String streamingMessageId;
  final int receivedCharacters;
  final bool canStop;

  const ChatbotMessageStreaming({
    required this.messages,
    this.currentSessionId,
    required this.streamingMessageId,
    this.receivedCharacters = 0,
    this.canStop = true,
  });

  @override
  List<Object?> get props => [
    messages,
    currentSessionId,
    streamingMessageId,
    receivedCharacters,
  ];
}

/// State when stream was stopped by user
class ChatbotMessageStopped extends ChatbotState {
  final List<ChatMessage> messages;
  final String? currentSessionId;
  final String stoppedMessageId;

  const ChatbotMessageStopped({
    required this.messages,
    this.currentSessionId,
    required this.stoppedMessageId,
  });

  @override
  List<Object?> get props => [messages, currentSessionId, stoppedMessageId];
}

/// State when reconnecting after network loss
class ChatbotReconnecting extends ChatbotState {
  final List<ChatMessage> messages;
  final String? currentSessionId;
  final int attemptNumber;

  const ChatbotReconnecting({
    required this.messages,
    this.currentSessionId,
    this.attemptNumber = 1,
  });

  @override
  List<Object?> get props => [messages, currentSessionId, attemptNumber];
}

/// State when animation is updating (frequent updates during streaming)
class ChatbotAnimationUpdate extends ChatbotState {
  final List<ChatMessage> messages;
  final String streamingMessageId;
  final int displayedCharacters;

  const ChatbotAnimationUpdate({
    required this.messages,
    required this.streamingMessageId,
    required this.displayedCharacters,
  });

  @override
  List<Object?> get props => [
    messages,
    streamingMessageId,
    displayedCharacters,
  ];
}
