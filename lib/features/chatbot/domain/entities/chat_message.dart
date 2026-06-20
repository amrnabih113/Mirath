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
  final List<String>? imagePaths;
  final Map<String, double>? uploadProgress;
  final bool isComplete;
  final bool isPending;
  final String? loadingStatus;
  final bool isError;

  // New fields for enhanced streaming UX
  final MessageStatus messageStatus;
  final String? actualResponse; // Full text from backend
  final String? displayedResponse; // Text currently shown (for animation)
  final String? streamError; // Error details if failed
  final bool canRegenerate;
  final bool canStop;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePaths,
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
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? imagePaths,
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
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imagePaths: imagePaths ?? this.imagePaths,
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
    );
  }
}
