import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/annotation_theme_colors.dart';
import 'paper_reading_shimmer_loading.dart';

class AnnotationSelectionData {
  final String text;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool hasFormula;
  final String? xpathStart;
  final String? xpathEnd;
  final int? startOffset;
  final int? endOffset;
  final String? plainText;
  final String? htmlContent;
  final String? contextBefore;
  final String? contextAfter;
  final int? wordCount;
  final String? firstWord;
  final String? lastWord;
  final int? selectedCharLength;

  const AnnotationSelectionData({
    required this.text,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.hasFormula,
    this.xpathStart,
    this.xpathEnd,
    this.startOffset,
    this.endOffset,
    this.plainText,
    this.htmlContent,
    this.contextBefore,
    this.contextAfter,
    this.wordCount,
    this.firstWord,
    this.lastWord,
    this.selectedCharLength,
  });

  factory AnnotationSelectionData.fromMap(Map<String, dynamic> map) {
    return AnnotationSelectionData(
      text: map['text'] as String? ?? '',
      x: (map['x'] as num?)?.toDouble() ?? 0,
      y: (map['y'] as num?)?.toDouble() ?? 0,
      width: (map['width'] as num?)?.toDouble() ?? 0,
      height: (map['height'] as num?)?.toDouble() ?? 0,
      hasFormula: map['hasFormula'] as bool? ?? false,
      xpathStart: map['xpathStart'] as String?,
      xpathEnd: map['xpathEnd'] as String?,
      startOffset: (map['startOffset'] as num?)?.toInt(),
      endOffset: (map['endOffset'] as num?)?.toInt(),
      plainText: map['plainText'] as String?,
      htmlContent: map['htmlContent'] as String?,
      contextBefore: map['contextBefore'] as String?,
      contextAfter: map['contextAfter'] as String?,
      wordCount: (map['wordCount'] as num?)?.toInt(),
      firstWord: map['firstWord'] as String?,
      lastWord: map['lastWord'] as String?,
      selectedCharLength: (map['selectedCharLength'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toHighlightMetadata() {
    return {
      'xpathStart': xpathStart,
      'xpathEnd': xpathEnd,
      'startOffset': startOffset,
      'endOffset': endOffset,
      'plainText': plainText ?? text,
      'htmlContent': htmlContent,
      'contextBefore': contextBefore,
      'contextAfter': contextAfter,
      'wordCount': wordCount,
      'firstWord': firstWord,
      'lastWord': lastWord,
      'selectedCharLength': selectedCharLength,
    };
  }
}

class AnnotationHighlightTapData {
  final String id;
  final double x;
  final double y;
  final double width;
  final double height;

  const AnnotationHighlightTapData({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory AnnotationHighlightTapData.fromMap(Map<String, dynamic> map) {
    return AnnotationHighlightTapData(
      id: map['id'] as String? ?? '',
      x: (map['x'] as num?)?.toDouble() ?? 0,
      y: (map['y'] as num?)?.toDouble() ?? 0,
      width: (map['width'] as num?)?.toDouble() ?? 0,
      height: (map['height'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AnnotationWebView extends StatefulWidget {
  final String content;
  final String paperId;
  final String? title;
  final List<String>? authors;
  final ValueChanged<AnnotationSelectionData>? onSelectionChanged;
  final VoidCallback? onSelectionCleared;
  final ValueChanged<AnnotationHighlightTapData>? onHighlightTapped;
  final ValueChanged<double>? onScrollProgress;
  final VoidCallback? onReady;

  const AnnotationWebView({
    super.key,
    required this.content,
    required this.paperId,
    this.title,
    this.authors,
    this.onSelectionChanged,
    this.onSelectionCleared,
    this.onHighlightTapped,
    this.onScrollProgress,
    this.onReady,
  });

  @override
  State<AnnotationWebView> createState() => AnnotationWebViewState();
}

class AnnotationWebViewState extends State<AnnotationWebView> {
  final Completer<void> _initialized = Completer<void>();
  final Map<String, Completer<dynamic>> _pending =
      <String, Completer<dynamic>>{};
  late final String _viewType;
  html.IFrameElement? _iframe;
  String? _html;
  StreamSubscription<html.MessageEvent>? _messageSubscription;
  int _requestCounter = 0;

  @override
  void initState() {
    super.initState();
    _viewType =
        'annotation-webview-${widget.paperId}-${DateTime.now().microsecondsSinceEpoch}';
    _prepare();
    _messageSubscription = html.window.onMessage.listen(_handleWindowMessage);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    for (final pending in _pending.values) {
      if (!pending.isCompleted) {
        pending.completeError(StateError('Annotation webview disposed'));
      }
    }
    _pending.clear();
    super.dispose();
  }

  Future<void> _prepare() async {
    final engineJs = await rootBundle.loadString(
      'lib/features/paper_annotations/assets/annotation_engine.js',
    );
    final themeColors = AnnotationThemeColors.light();
    _html = _buildHtml(engineJs, themeColors);

    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.display = 'block'
        ..srcdoc = _html
        ..allow = 'clipboard-read; clipboard-write';
      _iframe = iframe;
      iframe.onLoad.listen((_) {
        if (!_initialized.isCompleted) {
          _initialized.complete();
        }
      });
      return iframe;
    });

    if (mounted) {
      setState(() {});
    }
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _generateHeader() {
    if (widget.title == null &&
        (widget.authors == null || widget.authors!.isEmpty)) {
      return '';
    }

    final titleHtml = widget.title != null
        ? '<h1 class="paper-title">${_escapeHtml(widget.title!)}</h1>'
        : '';
    final authorsHtml = widget.authors != null && widget.authors!.isNotEmpty
        ? '<p class="paper-authors">${_escapeHtml(widget.authors!.join(', '))}</p>'
        : '';

    return '<div class="paper-header">$titleHtml$authorsHtml</div>';
  }

  String _buildHtml(String engineJs, AnnotationThemeColors themeColors) {
    final bgColor = _colorToHex(themeColors.backgroundColor);
    final textColor = _colorToHex(themeColors.textColor);
    final borderColor = _colorToHex(themeColors.borderColor);
    final primaryColorHex = _colorToHex(themeColors.primaryColor);
    final themeJson = jsonEncode({
      'primaryColor': primaryColorHex,
      'backgroundColor': bgColor,
      'textColor': textColor,
      'borderColor': borderColor,
      'highlightColors': themeColors.highlightColors,
    });
    final content = widget.content;
    final header = _generateHeader();

    return '''
<!DOCTYPE html>
<html dir="auto">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, maximum-scale=5.0, user-scalable=yes">
  <script>
    window.AnnotationBridge = {
      postMessage: function(message) {
        parent.postMessage({ kind: 'bridge', message: message }, '*');
      }
    };

    window.addEventListener('message', async function(event) {
      const data = event.data || {};
      if (data.kind !== 'command') return;

      try {
        const command = data.command;
        const args = data.args || [];
        let result = null;

        if (command === 'init') {
          result = AnnotationEngine.init(args[0]);
        } else if (typeof AnnotationEngine[command] === 'function') {
          result = AnnotationEngine[command].apply(AnnotationEngine, args);
        } else {
          throw new Error('Unknown command: ' + command);
        }

        result = await Promise.resolve(result);
        parent.postMessage({ kind: 'response', id: data.id, result: result }, '*');
      } catch (error) {
        parent.postMessage({ kind: 'response', id: data.id, error: String(error) }, '*');
      }
    });

    window.addEventListener('load', function() {
      try {
        AnnotationEngine.init($themeJson);
        parent.postMessage({ kind: 'ready' }, '*');
      } catch (error) {
        parent.postMessage({ kind: 'bridge', message: JSON.stringify({ action: 'error', message: String(error) }) }, '*');
      }
    });
  </script>
  <script>
$engineJs
  </script>
  <style>
    :root { --paper-font-scale: 1; --paper-base-font-size: 16px; }
    * { box-sizing: border-box; -webkit-user-select: text; user-select: text; }
    html, body { width: 100%; height: 100%; max-width: 100%; overflow-x: hidden; }
    body {
      width: 100%; min-height: 100vh; margin: 0;
      font-family: Arial, sans-serif;
      font-size: calc(var(--paper-base-font-size) * var(--paper-font-scale));
      line-height: 1.7; padding: clamp(12px, 3.5vw, 20px);
      color: $textColor; background-color: $bgColor; direction: auto;
      word-break: break-word; overflow-wrap: break-word;
    }
    img, table, figure, svg, video, canvas, iframe, object, embed { max-width: 100% !important; height: auto !important; }
    table, pre { display: block; overflow-x: auto; max-width: 100%; border-collapse: collapse; }
    .paper-header { margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid $borderColor; }
    .paper-title { font-size: 24px; font-weight: 500; line-height: 1.4; margin: 0 0 12px 0; color: $textColor; }
    .paper-authors { font-size: 16px; margin: 0; color: #1a1a1a; }
    a { color: $primaryColorHex; text-decoration: underline; }
    .annotation-highlight { cursor: pointer; border-radius: 2px; transition: opacity 0.2s ease; display: inline; padding: 1px 2px; color: inherit !important; }
    .search-highlight { background: rgba(62, 138, 255, 0.35); border-radius: 2px; padding: 0 1px; }
    .search-highlight-active { background: rgba(62, 138, 255, 0.7); outline: 1px solid rgba(62, 138, 255, 0.9); }
    h1, h2, h3, h4, h5, h6 { font-weight: 600; margin: 24px 0 12px 0; line-height: 1.3; }
  </style>
</head>
<body>
  $header
  $content
</body>
</html>
''';
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  void _handleWindowMessage(html.MessageEvent event) {
    final data = event.data;
    if (data is! Map) return;

    final kind = data['kind'] as String?;
    switch (kind) {
      case 'bridge':
        _handleBridgeMessage(data['message']?.toString() ?? '');
        break;
      case 'response':
        final id = data['id']?.toString();
        if (id == null) return;
        final pending = _pending.remove(id);
        if (pending == null || pending.isCompleted) return;
        if (data.containsKey('error')) {
          pending.completeError(Exception(data['error'].toString()));
        } else {
          pending.complete(data['result']);
        }
        break;
      case 'ready':
        if (!_initialized.isCompleted) {
          _initialized.complete();
        }
        if (mounted) widget.onReady?.call();
        break;
    }
  }

  void _handleBridgeMessage(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      switch (data['action'] as String?) {
        case 'text_selected':
          widget.onSelectionChanged?.call(
            AnnotationSelectionData.fromMap(data),
          );
          break;
        case 'selection_cleared':
          widget.onSelectionCleared?.call();
          break;
        case 'highlight_clicked':
          widget.onHighlightTapped?.call(
            AnnotationHighlightTapData.fromMap(data),
          );
          break;
        case 'scroll_progress':
          widget.onScrollProgress?.call(
            (data['progress'] as num?)?.toDouble() ?? 0,
          );
          break;
      }
    } catch (_) {
      // Ignore bridge parse errors.
    }
  }

  Future<T> _invoke<T>(String command, [List<dynamic> args = const []]) async {
    await _initialized.future.timeout(const Duration(seconds: 10));
    final id = '${DateTime.now().microsecondsSinceEpoch}_${_requestCounter++}';
    final completer = Completer<dynamic>();
    _pending[id] = completer;

    _iframe?.contentWindow?.postMessage({
      'kind': 'command',
      'id': id,
      'command': command,
      'args': args,
    }, '*');

    final result = await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        _pending.remove(id);
        throw TimeoutException('Timed out waiting for $command');
      },
    );

    return result as T;
  }

  Future<bool> applyHighlight(
    String highlightId,
    String text,
    String color, [
    Map<String, dynamic>? metadata,
  ]) async {
    final result = await _invoke<dynamic>('applyHighlight', [
      highlightId,
      text,
      color,
      metadata,
    ]);
    return _coerceBool(result);
  }

  Future<void> updateHighlightColor(String highlightId, String color) async {
    await _invoke<dynamic>('updateColor', [highlightId, color]);
  }

  Future<void> removeHighlight(String highlightId) async {
    await _invoke<dynamic>('removeHighlight', [highlightId]);
  }

  Future<bool> restoreHighlight(
    String highlightId,
    String text,
    String color, [
    Map<String, dynamic>? metadata,
  ]) async {
    final result = await _invoke<dynamic>('restoreHighlight', [
      highlightId,
      text,
      color,
      metadata,
    ]);
    return _coerceBool(result);
  }

  Future<bool> scrollToHighlight(String highlightId) async {
    final result = await _invoke<dynamic>('scrollToHighlight', [highlightId]);
    return _coerceBool(result);
  }

  Future<List<Map<String, dynamic>>> getHighlights() async {
    final result = await _invoke<dynamic>('getHighlights');
    if (result is List) {
      return result
          .whereType<Map>()
          .map(
            (item) => item.map((key, value) => MapEntry(key.toString(), value)),
          )
          .toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> searchText(String query) async {
    final result = await _invoke<dynamic>('searchText', [query]);
    return _coerceMap(result);
  }

  Future<Map<String, dynamic>> searchNext() async {
    final result = await _invoke<dynamic>('searchNext');
    return _coerceMap(result);
  }

  Future<Map<String, dynamic>> searchPrevious() async {
    final result = await _invoke<dynamic>('searchPrevious');
    return _coerceMap(result);
  }

  Future<void> clearSearch() async {
    await _invoke<dynamic>('clearSearch');
  }

  Future<Map<String, dynamic>> getSearchStatus() async {
    final result = await _invoke<dynamic>('getSearchStatus');
    return _coerceMap(result);
  }

  Future<void> setFontScale(double scale) async {
    await _invoke<dynamic>('setFontScale', [scale]);
  }

  Future<void> retypesetMath() async {
    await _invoke<dynamic>('retypesetMath');
  }

  bool _coerceBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  Map<String, dynamic> _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {'total': 0, 'current': 0};
  }

  @override
  Widget build(BuildContext context) {
    if (_html == null) {
      return const PaperReadingShimmerLoading();
    }

    return HtmlElementView(viewType: _viewType);
  }
}
