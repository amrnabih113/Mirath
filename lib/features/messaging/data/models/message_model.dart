class MessageModel {
  final String id;
  final String? clientId;
  final String conversationId;
  final String senderId;
  final String text;
  final String status; // pending, sent, failed
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageModel({
    required this.id,
    this.clientId,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? '',
      clientId: json['clientId']?.toString(),
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      status: json['status']?.toString() ?? 'sent',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (clientId != null) 'clientId': clientId,
    'conversationId': conversationId,
    'senderId': senderId,
    'text': text,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
