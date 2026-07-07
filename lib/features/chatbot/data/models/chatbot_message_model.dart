
import '../../domain/entities/chat_message.dart';
import 'chatbot_message_attachment.dart';

class ChatbotMessageModel {
  final String id;
  final String role;
  final String type;
  final String content;
  final DateTime? createdAt;
  final String? feedbackType;
  final List<MessageAttachment> attachments;

  ChatbotMessageModel({
    required this.id,
    required this.role,
    required this.type,
    required this.content,
    required this.attachments,
    this.createdAt,
    this.feedbackType,
  });

  factory ChatbotMessageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    String? feedbackType;

    if (data['feedback'] != null) {
      feedbackType = data['feedback']['type']?.toString();
    }

    final attachments =
        (data['attachments'] as List<dynamic>? ?? [])
            .map((e) => MessageAttachment.fromJson(e))
            .toList();

    return ChatbotMessageModel(
      id: data['id']?.toString() ?? '',
      role: data['role']?.toString() ?? 'USER',
      type: data['type']?.toString() ?? 'TEXT',
      content: data['content']?.toString() ?? '',
      attachments: attachments,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
      feedbackType: feedbackType,
    );
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      text: content,
      isUser: role.toUpperCase() == 'USER',
      timestamp: createdAt ?? DateTime.now(),
      attachments: attachments,
      isComplete: true,
      isPending: false,
      userFeedback: feedbackType,
    );
  }
}