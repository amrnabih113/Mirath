import '../../domain/entites/highlight_entity.dart';

class HighlightModel extends Highlight {
  HighlightModel({
    required super.id,
    required super.paperId,
    required super.selectedText,
    super.note,
    super.links,
    required super.color,
    required super.createdAt,
    super.xpathStart,
    super.xpathEnd,
    super.startOffset,
    super.endOffset,
    super.plainText,
    super.htmlContent,
    super.contextBefore,
    super.contextAfter,
    super.firstWord,
    super.lastWord,
    super.selectedWordCount,
    super.selectedCharLength,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json['id'] as String,
      paperId: json['paperId'] as String,
      selectedText: json['selectedText'] as String? ?? '',
      note: json['note'] as String?,
      links:
          (json['links'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[],
      color: _apiColorToHex(json['color'] as String?),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      xpathStart: json['xpathStart'] as String?,
      xpathEnd: json['xpathEnd'] as String?,
      startOffset: (json['startOffset'] as num?)?.toInt(),
      endOffset: (json['endOffset'] as num?)?.toInt(),
      plainText: json['plainText'] as String?,
      htmlContent: json['htmlContent'] as String?,
      contextBefore: json['contextBefore'] as String?,
      contextAfter: json['contextAfter'] as String?,
      firstWord: json['firstWord'] as String?,
      lastWord: json['lastWord'] as String?,
      selectedWordCount: (json['selectedWordCount'] as num?)?.toInt(),
      selectedCharLength: (json['selectedCharLength'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paperId': paperId,
      'selectedText': selectedText,
      'note': note,
      'links': links,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'xpathStart': xpathStart,
      'xpathEnd': xpathEnd,
      'startOffset': startOffset,
      'endOffset': endOffset,
      'plainText': plainText,
      'htmlContent': htmlContent,
      'contextBefore': contextBefore,
      'contextAfter': contextAfter,
      'firstWord': firstWord,
      'lastWord': lastWord,
      'selectedWordCount': selectedWordCount,
      'selectedCharLength': selectedCharLength,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'color': _hexColorToApi(color),
      if (note != null) 'note': note,
      if (xpathStart != null) 'xpathStart': xpathStart,
      if (xpathEnd != null) 'xpathEnd': xpathEnd,
      if (startOffset != null) 'startOffset': startOffset,
      if (endOffset != null) 'endOffset': endOffset,
      if (selectedText.isNotEmpty) 'selectedText': selectedText,
      if (plainText != null) 'plainText': plainText,
      if (htmlContent != null) 'htmlContent': htmlContent,
      if (contextBefore != null) 'contextBefore': contextBefore,
      if (contextAfter != null) 'contextAfter': contextAfter,
      if (firstWord != null) 'firstWord': firstWord,
      if (lastWord != null) 'lastWord': lastWord,
      if (selectedWordCount != null) 'selectedWordCount': selectedWordCount,
      if (selectedCharLength != null) 'selectedCharLength': selectedCharLength,
    };
  }

  Map<String, dynamic> toColorUpdateJson() {
    return {'color': _hexColorToApi(color)};
  }

  factory HighlightModel.fromEntity(Highlight highlight) {
    return HighlightModel(
      id: highlight.id,
      paperId: highlight.paperId,
      selectedText: highlight.selectedText,
      note: highlight.note,
      links: highlight.links,
      color: highlight.color,
      createdAt: highlight.createdAt,
      xpathStart: highlight.xpathStart,
      xpathEnd: highlight.xpathEnd,
      startOffset: highlight.startOffset,
      endOffset: highlight.endOffset,
      plainText: highlight.plainText,
      htmlContent: highlight.htmlContent,
      contextBefore: highlight.contextBefore,
      contextAfter: highlight.contextAfter,
      firstWord: highlight.firstWord,
      lastWord: highlight.lastWord,
      selectedWordCount: highlight.selectedWordCount,
      selectedCharLength: highlight.selectedCharLength,
    );
  }

  static String _apiColorToHex(String? color) {
    switch ((color ?? '').toUpperCase()) {
      case 'GREEN':
        return '#A6E1C5';
      case 'BLUE':
        return '#A7E0F6';
      case 'PURPLE':
        return '#E1A7FB';
      case 'PINK':
      case 'RED':
        return '#FF9FAE';
      case 'YELLOW':
        return '#FDE995';
      default:
        final normalized = color?.trim();
        if (normalized == null || normalized.isEmpty) return '#FFE082';
        if (normalized.startsWith('#')) {
          return normalized.toUpperCase();
        }
        return '#FFE082';
    }
  }

  static String _hexColorToApi(String color) {
    final normalized = color.replaceAll('#', '').toUpperCase();
    switch (normalized) {
      case 'FDE995':
      case 'FFE082':
        return 'YELLOW';
      case 'A6E1C5':
        return 'GREEN';
      case 'A7E0F6':
      case '9FA5FF':
        return 'BLUE';
      case 'E1A7FB':
        return 'PURPLE';
      case 'FF9FAE':
        return 'RED';
      default:
        return 'YELLOW';
    }
  }
}
