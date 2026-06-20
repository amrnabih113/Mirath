import '../../domain/entities/chat_message.dart';

class ChatbotMessageModel {
  final String id;
  final String role;
  final String content;
  final DateTime? createdAt;

  ChatbotMessageModel({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  factory ChatbotMessageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ChatbotMessageModel(
      id: data['id']?.toString() ?? '',
      role: data['role']?.toString() ?? 'USER',
      content: data['content']?.toString() ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
    );
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      text: content,
      isUser: role.toUpperCase() == 'USER',
      timestamp: createdAt ?? DateTime.now(),
      isComplete: true,
      isPending: false,
    );
  }
}
