enum AttachmentType { image, audio }

class MessageAttachment {
  final String id;

  /// IMAGE / AUDIO
  final AttachmentType type;

  /// Local file before upload
  final String? localPath;

  /// Server URL after upload
  final String? url;

  final String? mimeType;
  final int? sizeBytes;
  final int? durationSeconds;

  /// 0.0 → 1.0
  final double uploadProgress;
  final DateTime? createdAt;

  const MessageAttachment({
    required this.id,
    required this.type,
    this.localPath,
    this.url,
    this.mimeType,
    this.sizeBytes,
    this.durationSeconds,
    this.uploadProgress = 1.0,
    this.createdAt,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id']?.toString() ?? '',
      type: switch (json['type']) {
        'IMAGE' => AttachmentType.image,
        'AUDIO' => AttachmentType.audio,
        _ => throw Exception('Unknown attachment type: ${json["type"]}'),
      },
      url: json['url']?.toString() ?? '',
      mimeType: json['mimeType']?.toString(),
      sizeBytes: json['sizeBytes'],
      durationSeconds: json['durationSeconds'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  MessageAttachment copyWith({
    String? id,
    AttachmentType? type,
    String? localPath,
    String? url,
    String? mimeType,
    int? sizeBytes,
    int? durationSeconds,
    double? uploadProgress,
    DateTime? createdAt,
  }) {
    return MessageAttachment(
      id: id ?? this.id,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      url: url ?? this.url,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

extension AttachmentTypeExtension on AttachmentType {
  String get apiValue {
    switch (this) {
      case AttachmentType.image:
        return 'IMAGE';
      case AttachmentType.audio:
        return 'AUDIO';
    }
  }

  static AttachmentType fromApi(String value) {
    switch (value) {
      case 'IMAGE':
        return AttachmentType.image;
      case 'AUDIO':
        return AttachmentType.audio;
      default:
        throw Exception('Unknown attachment type: $value');
    }
  }
}
