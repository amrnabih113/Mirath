class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? imagePaths;
  final bool isComplete;
  final bool isPending;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePaths,
    this.isComplete = true,
    this.isPending = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? imagePaths,
    bool? isComplete,
    bool? isPending,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imagePaths: imagePaths ?? this.imagePaths,
      isComplete: isComplete ?? this.isComplete,
      isPending: isPending ?? this.isPending,
    );
  }
}
