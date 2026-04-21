class Highlight {
  final String id;
  final String paperId;
  final String selectedText;
  final String? note;
  final List<String> links;
  final String color; // hex code: "#FFEB3B"
  final DateTime createdAt;

  // XPath information for efficient highlight restoration
  final String? xpathStart;
  final String? xpathEnd; 
  final int? startOffset;
  final int? endOffset;
  final String? plainText;
  final String? htmlContent;
  final String? contextBefore;
  final String? contextAfter;
  final String? firstWord;
  final String? lastWord;
  final int? selectedWordCount;
  final int? selectedCharLength;

  Highlight({
    required this.id,
    required this.paperId,
    required this.selectedText,
    this.note,
    this.links = const [],
    required this.color,
    required this.createdAt,
    this.xpathStart,
    this.xpathEnd,
    this.startOffset,
    this.endOffset,
    this.plainText,
    this.htmlContent,
    this.contextBefore,
    this.contextAfter,
    this.firstWord,
    this.lastWord,
    this.selectedWordCount,
    this.selectedCharLength,
  });

  // Behavior: add a note
  Highlight copyWithNote(String note) {
    return Highlight(
      id: id,
      paperId: paperId,
      selectedText: selectedText,
      note: note,
      links: links,
      color: color,
      createdAt: createdAt,
      xpathStart: xpathStart,
      xpathEnd: xpathEnd,
      startOffset: startOffset,
      endOffset: endOffset,
      plainText: plainText,
      htmlContent: htmlContent,
      contextBefore: contextBefore,
      contextAfter: contextAfter,
      firstWord: firstWord,
      lastWord: lastWord,
      selectedWordCount: selectedWordCount,
      selectedCharLength: selectedCharLength,
    );
  }

  // Behavior: change color
  Highlight copyWithColor(String newColor) {
    return Highlight(
      id: id,
      paperId: paperId,
      selectedText: selectedText,
      note: note,
      links: links,
      color: newColor,
      createdAt: createdAt,
      xpathStart: xpathStart,
      xpathEnd: xpathEnd,
      startOffset: startOffset,
      endOffset: endOffset,
      plainText: plainText,
      htmlContent: htmlContent,
      contextBefore: contextBefore,
      contextAfter: contextAfter,
      firstWord: firstWord,
      lastWord: lastWord,
      selectedWordCount: selectedWordCount,
      selectedCharLength: selectedCharLength,
    );
  }

  // Behavior: copy with XPath data (for persistence)
  Highlight copyWithXPath({
    required String xpathStart,
    required String xpathEnd,
    required int startOffset,
    required int endOffset,
    required String plainText,
    String? htmlContent,
  }) {
    return Highlight(
      id: id,
      paperId: paperId,
      selectedText: selectedText,
      note: note,
      links: links,
      color: color,
      createdAt: createdAt,
      xpathStart: xpathStart,
      xpathEnd: xpathEnd,
      startOffset: startOffset,
      endOffset: endOffset,
      plainText: plainText,
      htmlContent: htmlContent,
      contextBefore: contextBefore,
      contextAfter: contextAfter,
      firstWord: firstWord,
      lastWord: lastWord,
      selectedWordCount: selectedWordCount,
      selectedCharLength: selectedCharLength,
    );
  }

  Highlight copyWith({
    String? id,
    String? paperId,
    String? selectedText,
    String? note,
    List<String>? links,
    String? color,
    DateTime? createdAt,
    String? xpathStart,
    String? xpathEnd,
    int? startOffset,
    int? endOffset,
    String? plainText,
    String? htmlContent,
    String? contextBefore,
    String? contextAfter,
    String? firstWord,
    String? lastWord,
    int? selectedWordCount,
    int? selectedCharLength,
  }) {
    return Highlight(
      id: id ?? this.id,
      paperId: paperId ?? this.paperId,
      selectedText: selectedText ?? this.selectedText,
      note: note ?? this.note,
      links: links ?? this.links,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      xpathStart: xpathStart ?? this.xpathStart,
      xpathEnd: xpathEnd ?? this.xpathEnd,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      plainText: plainText ?? this.plainText,
      htmlContent: htmlContent ?? this.htmlContent,
      contextBefore: contextBefore ?? this.contextBefore,
      contextAfter: contextAfter ?? this.contextAfter,
      firstWord: firstWord ?? this.firstWord,
      lastWord: lastWord ?? this.lastWord,
      selectedWordCount: selectedWordCount ?? this.selectedWordCount,
      selectedCharLength: selectedCharLength ?? this.selectedCharLength,
    );
  }

  Map<String, dynamic> toMap() {
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

  factory Highlight.fromMap(Map<String, dynamic> map) {
    return Highlight(
      id: map['id'] as String,
      paperId: map['paperId'] as String,
      selectedText: map['selectedText'] as String? ?? '',
      note: map['note'] as String?,
      links:
          (map['links'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[],
      color: map['color'] as String? ?? '#FFE082',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      xpathStart: map['xpathStart'] as String?,
      xpathEnd: map['xpathEnd'] as String?,
      startOffset: (map['startOffset'] as num?)?.toInt(),
      endOffset: (map['endOffset'] as num?)?.toInt(),
      plainText: map['plainText'] as String?,
      htmlContent: map['htmlContent'] as String?,
      contextBefore: map['contextBefore'] as String?,
      contextAfter: map['contextAfter'] as String?,
      firstWord: map['firstWord'] as String?,
      lastWord: map['lastWord'] as String?,
      selectedWordCount: (map['selectedWordCount'] as num?)?.toInt(),
      selectedCharLength: (map['selectedCharLength'] as num?)?.toInt(),
    );
  }

  /// Get the most reliable identifier for text matching
  /// Prioritizes plainText for efficient text-based matching in JavaScript
  String getMatchText() {
    return plainText ?? selectedText;
  }

  /// Check if XPath data is available for restoration
  bool hasXPathData() {
    return xpathStart != null &&
        xpathEnd != null &&
        startOffset != null &&
        endOffset != null;
  }
}
