import '../../data/models/chatbot_message_attachment.dart';

enum MessageStatus {
  draft,
  sending,
  waiting,
  receiving,
  streaming,
  completed,
  stopped,
  failed,
  retrying,
}
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  /// Legacy (will remove later)
  final List<String>? imagePaths;

  /// New
  final List<MessageAttachment> attachments;

  final Map<String, double>? uploadProgress;
  final bool isComplete;
  final bool isPending;
  final String? loadingStatus;
  final bool isError;

  final MessageStatus messageStatus;
  final String? actualResponse;
  final String? displayedResponse;
  final String? streamError;
  final bool canRegenerate;
  final bool canStop;

  final String? userFeedback;
  final bool isFeedbackSubmitting;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePaths,
    this.attachments = const [],
    this.uploadProgress,
    this.isComplete = true,
    this.isPending = false,
    this.loadingStatus,
    this.isError = false,
    this.messageStatus = MessageStatus.completed,
    this.actualResponse,
    this.displayedResponse,
    this.streamError,
    this.canRegenerate = false,
    this.canStop = false,
    this.userFeedback,
    this.isFeedbackSubmitting = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? imagePaths,
    List<MessageAttachment>? attachments,
    Map<String, double>? uploadProgress,
    bool? isComplete,
    bool? isPending,
    String? loadingStatus,
    bool? isError,
    MessageStatus? messageStatus,
    String? actualResponse,
    String? displayedResponse,
    String? streamError,
    bool? canRegenerate,
    bool? canStop,
    String? userFeedback,
    bool? isFeedbackSubmitting,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imagePaths: imagePaths ?? this.imagePaths,
      attachments: attachments ?? this.attachments,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isComplete: isComplete ?? this.isComplete,
      isPending: isPending ?? this.isPending,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      isError: isError ?? this.isError,
      messageStatus: messageStatus ?? this.messageStatus,
      actualResponse: actualResponse ?? this.actualResponse,
      displayedResponse: displayedResponse ?? this.displayedResponse,
      streamError: streamError ?? this.streamError,
      canRegenerate: canRegenerate ?? this.canRegenerate,
      canStop: canStop ?? this.canStop,
      userFeedback: userFeedback ?? this.userFeedback,
      isFeedbackSubmitting:
          isFeedbackSubmitting ?? this.isFeedbackSubmitting,
    );
  }
}