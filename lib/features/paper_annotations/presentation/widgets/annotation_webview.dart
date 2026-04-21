import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_logger.dart';
import 'package:mirath/features/paper_annotations/presentation/utils/annotation_theme_colors.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/paper_reading_shimmer_loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
  late final WebViewController _controller;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    debugPrint('[AnnotationWebView] _initializeWebView() called');
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(MyColors.light)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: _onPageFinished,
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (request) {
            // Allow loading the initial HTML content
            if (request.url.startsWith('data:') ||
                request.url.startsWith('about:')) {
              return NavigationDecision.navigate;
            }

            // Open external links in browser
            if (request.url.startsWith('http://') ||
                request.url.startsWith('https://')) {
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'AnnotationBridge',
        onMessageReceived: _handleJavaScriptMessage,
      );

    debugPrint(
      '[AnnotationWebView] WebViewController configured, scheduling content load',
    );

    // Defer content loading until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[AnnotationWebView] _loadContent() callback executing');
      _loadContent();
    });
  }

  Future<void> _loadContent() async {
    debugPrint('[AnnotationWebView] 🔥🔥🔥 _loadContent() START');
    // Always use light theme for paper reading content
    final themeColors = AnnotationThemeColors.light();
    final themedCss = _generateThemedCSS(themeColors);

    // Generate header with title and authors if provided
    final headerHtml = _generateHeader();

    debugPrint(
      '[AnnotationWebView] Content length: ${widget.content.length} chars',
    );

    final html =
        r'''
<!DOCTYPE html>
<html dir="auto">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, maximum-scale=5.0, user-scalable=yes">
  
  <!-- MathJax Configuration -->
  <script>
    window.MathJax = {
      tex: {
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']],
        processEscapes: true,
        processEnvironments: true,
        packages: {'[+]': ['ams', 'newcommand', 'configmacros']}
      },
      svg: {
        fontCache: 'global',
        scale: 1,
        minScale: 0.5,
        matchFontHeight: true
      },
      options: {
        skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
        ignoreHtmlClass: 'annotation-highlight|search-highlight'
      },
      startup: {
        pageReady: function () {
          return MathJax.startup.defaultPageReady().then(function () {
            console.log('MathJax initial typesetting complete');
            // Make math selectable after rendering
            document.querySelectorAll('mjx-container').forEach(function(el) {
              el.style.userSelect = 'text';
              el.style.webkitUserSelect = 'text';
            });
          });
        }
      }
    };
  </script>
  
  <!-- MathJax Library -->
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js" async></script>
  
  <style>
    ''' +
        themedCss +
        r'''
  </style>
</head>
<body>
  ''' +
        headerHtml +
        widget.content +
        r'''
</body>
</html>
''';

    debugPrint('[AnnotationWebView] 🔥🔥🔥 Calling loadHtmlString...');
    await _controller.loadHtmlString(html);
    debugPrint('[AnnotationWebView] 🔥🔥🔥 loadHtmlString completed');
  }

  String _generateHeader() {
    if (widget.title == null &&
        (widget.authors == null || widget.authors!.isEmpty)) {
      return '';
    }

    final titleHtml = widget.title != null
        ? '<h1 class="paper-title">${_escapeHtml(widget.title!)}</h1>'
        : '';

    String authorsHtml = '';
    if (widget.authors != null && widget.authors!.isNotEmpty) {
      final authorsText = widget.authors!.join(', ');
      authorsHtml = '<p class="paper-authors">${_escapeHtml(authorsText)}</p>';
    }

    return '''
<div class="paper-header">
  $titleHtml
  $authorsHtml
</div>
''';
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _generateThemedCSS(AnnotationThemeColors themeColors) {
    final bgColor = _colorToHex(themeColors.backgroundColor);
    final textColor = _colorToHex(themeColors.textColor);
    final borderColor = _colorToHex(themeColors.borderColor);
    final primaryColorHex = _colorToHex(themeColors.primaryColor);

    return '''
    @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Source+Serif+4:wght@400;600&display=swap');

    :root {
      --paper-font-scale: 1;
      --paper-base-font-size: 16px;
    }

    * {
      -webkit-touch-callout: default;
      box-sizing: border-box;
      /* Prevent long-press menu */
      -webkit-user-select: text;
      user-select: text;
    }

    html, body {
      width: 100%;
      height: 100%;
      max-width: 100%;
      overflow-x: hidden;
    }

    body {
      width: 100%;
      min-height: 100vh;
      font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      font-size: calc(var(--paper-base-font-size) * var(--paper-font-scale));
      line-height: 1.7;
      padding: clamp(12px, 3.5vw, 20px);
      margin: 0;
      color: $textColor;
      background-color: $bgColor;
      direction: auto;
      text-size-adjust: 100%;
      -webkit-text-size-adjust: 100%;
      word-break: break-word;
      overflow-wrap: break-word;
      overflow-x: hidden;
      user-select: text;
      -webkit-user-select: text;
    }

    img, table, figure, svg, video, canvas, iframe, object, embed {
      max-width: 100% !important;
      height: auto !important;
    }

    table, pre {
      display: block;
      overflow-x: auto;
      max-width: 100%;
      border-collapse: collapse;
      -webkit-overflow-scrolling: touch;
    }

    mjx-container, .MathJax, .katex-display {
      display: block;
      max-width: 100%;
      overflow-x: auto;
      overflow-y: hidden;
      -webkit-overflow-scrolling: touch;
    }

    .ltx_page_main,
    .ltx_document,
    .ltx_abstract,
    .ltx_section,
    .ltx_para,
    .ltx_tabular {
      width: auto !important;
      max-width: 100% !important;
    }

    body, p, div, span, h1, h2, h3, h4, h5, h6, li, td, th {
      user-select: text !important;
      -webkit-user-select: text !important;
      -moz-user-select: text !important;
    }

    body * {
      user-select: text !important;
      -webkit-user-select: text !important;
    }

    .MathJax, .MathJax *, .katex, .katex *, mjx-container, mjx-container *,
    svg, svg *, .mjx-mrow, .mjx-mn, .mjx-mi, .mjx-mo, .ltx_Math, .ltx_Math * {
      user-select: text !important;
      -webkit-user-select: text !important;
    }

    [dir="rtl"] {
      direction: rtl;
      text-align: right;
    }

    code, pre, .code, .highlight {
      user-select: text !important;
      -webkit-user-select: text !important;
      background-color: rgba(0, 0, 0, 0.05);
      padding: 2px 4px;
      border-radius: 2px;
    }

    .annotation-highlight {
      cursor: pointer;
      border-radius: 2px;
      transition: opacity 0.2s ease;
      display: inline;
      padding: 1px 2px;
      color: inherit !important;
      -webkit-text-fill-color: currentColor !important;
      fill: currentColor !important;
      stroke: inherit !important;
    }

    .annotation-highlight:hover {
      opacity: 0.8 !important;
    }

    .search-highlight {
      background: rgba(62, 138, 255, 0.35);
      border-radius: 2px;
      padding: 0 1px;
    }

    .search-highlight-active {
      background: rgba(62, 138, 255, 0.7);
      outline: 1px solid rgba(62, 138, 255, 0.9);
    }

    a {
      color: $primaryColorHex;
      text-decoration: underline;
      cursor: pointer;
      word-break: break-word;
    }

    a:hover {
      color: $primaryColorHex;
      opacity: 0.8;
    }

    a:active {
      color: $primaryColorHex;
      opacity: 0.6;
    }

    hr, fieldset {
      border-color: $borderColor;
    }

    /* Hide beta banner only */
    [class*="beta"],
    [id*="beta"],
    [data-testid*="beta"],
    [aria-label*="beta"] {
      display: none !important;
    }

    /* Paper header styling - matching PaperInfo widget */
    .paper-header {
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 1px solid $borderColor;
    }

    .paper-title {
      font-family: 'Roboto', sans-serif;
      font-size: 24px;
      font-weight: 500;
      line-height: 1.4;
      margin: 0 0 12px 0;
      color: $textColor;
    }

    .paper-authors {
      font-family: 'Source Serif 4', serif;
      font-size: 16px;
      font-weight: 400;
      line-height: 1.5;
      margin: 0;
      color: #1a1a1a;
    }

    /* Content styling - headers with Source Serif 4 */
    h1, h2, h3, h4, h5, h6 {
      font-family: 'Source Serif 4', serif;
      font-weight: 600;
      margin: 24px 0 12px 0;
      line-height: 1.3;
    }

    h1 { font-size: 28px; }
    h2 { font-size: 24px; }
    h3 { font-size: 20px; }
    h4 { font-size: 18px; }
    h5 { font-size: 16px; }
    h6 { font-size: 14px; }

    @media (max-width: 600px) {
      :root {
        --paper-base-font-size: 15px;
      }

      .paper-header {
        margin-bottom: 18px;
        padding-bottom: 12px;
      }

      .paper-title {
        font-size: 22px;
        line-height: 1.35;
      }

      .paper-authors {
        font-size: 15px;
      }

      h1 { font-size: 24px; }
      h2 { font-size: 21px; }
      h3 { font-size: 19px; }
      h4 { font-size: 17px; }
      h5 { font-size: 15px; }
      h6 { font-size: 14px; }
    }

    /* Fix abstract title to match other titles */
    .ltx_title_abstract {
      font-family: 'Source Serif 4', serif !important;
      font-weight: 600 !important;
      font-size: 24px !important;
      margin: 24px 0 12px 0 !important;
      line-height: 1.3 !important;
    }

    p {
      margin: 12px 0;
      line-height: 1.7;
    }
    ''';
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Future<void> _onPageFinished(String url) async {
    if (_isLoaded) return;

    debugPrint(
      '[AnnotationWebView] 🔥 _onPageFinished called - loading AnnotationEngine.js',
    );
    final jsCode = await rootBundle.loadString(
      'lib/features/paper_annotations/assets/annotation_engine.js',
    );
    debugPrint(
      '[AnnotationWebView] 🔥 AnnotationEngine.js loaded, executing...',
    );
    await _controller.runJavaScript(jsCode);
    debugPrint('[AnnotationWebView] 🔥 AnnotationEngine.js executed');

    // Always use light theme for paper reading content
    final themeColors = AnnotationThemeColors.light();

    final themeJson = jsonEncode({
      'primaryColor': _colorToHex(themeColors.primaryColor),
      'backgroundColor': _colorToHex(themeColors.backgroundColor),
      'textColor': _colorToHex(themeColors.textColor),
      'borderColor': _colorToHex(themeColors.borderColor),
      'highlightColors': themeColors.highlightColors,
    });

    await _controller.runJavaScript('AnnotationEngine.init($themeJson);');

    if (mounted) {
      setState(() {
        _isLoaded = true;
      });
    }

    widget.onReady?.call();
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    if (!mounted) {
      return;
    }

    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final action = data['action'] as String?;

      switch (action) {
        case 'text_selected':
          widget.onSelectionChanged?.call(
            AnnotationSelectionData.fromMap(data),
          );
          break;
        case 'selection_cleared':
          widget.onSelectionCleared?.call();
          break;
        case 'highlight_clicked':
          final tapData = AnnotationHighlightTapData.fromMap(data);
          if (tapData.id.isNotEmpty) {
            widget.onHighlightTapped?.call(tapData);
          }
          break;
        case 'scroll_progress':
          final progress = (data['progress'] as num?)?.toDouble() ?? 0;
          widget.onScrollProgress?.call(progress);
          break;
        default:
          break;
      }
    } catch (error) {
      debugPrint('Error parsing JavaScript message: $error');
    }
  }

  dynamic _decodeJsValue(dynamic value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return trimmed;

      try {
        return jsonDecode(trimmed);
      } catch (_) {
        if (trimmed.startsWith('"') && trimmed.endsWith('"')) {
          return trimmed.substring(1, trimmed.length - 1);
        }
      }
    }

    return value;
  }

  Future<bool> applyHighlight(
    String highlightId,
    String text,
    String color, [
    Map<String, dynamic>? metadata,
  ]) async {
    if (!_isLoaded) return false;

    final argsJson = jsonEncode({
      'id': highlightId,
      'text': text,
      'color': color,
      'metadata': metadata,
    });
    final raw = await _controller.runJavaScriptReturningResult(
      '(function(){const args = $argsJson; return AnnotationEngine.applyHighlight(args.id, args.text, args.color, args.metadata);})();',
    );

    final decoded = _decodeJsValue(raw);
    if (decoded is bool) return decoded;
    if (decoded is num) return decoded != 0;
    if (decoded is String) return decoded.toLowerCase() == 'true';
    return false;
  }

  Future<void> updateHighlightColor(String highlightId, String color) async {
    if (!_isLoaded) return;

    await _controller.runJavaScript(
      "AnnotationEngine.updateColor('$highlightId', '$color');",
    );
  }

  Future<void> removeHighlight(String highlightId) async {
    if (!_isLoaded) return;

    await _controller.runJavaScript(
      "AnnotationEngine.removeHighlight('$highlightId');",
    );
  }

  Future<bool> restoreHighlight(
    String highlightId,
    String text,
    String color, [
    Map<String, dynamic>? metadata,
  ]) async {
    if (!_isLoaded) return false;

    final argsJson = jsonEncode({
      'id': highlightId,
      'text': text,
      'color': color,
      'metadata': metadata,
    });
    final raw = await _controller.runJavaScriptReturningResult(
      '(function(){const args = $argsJson; return AnnotationEngine.restoreHighlight(args.id, args.text, args.color, args.metadata);})();',
    );

    final decoded = _decodeJsValue(raw);
    if (decoded is bool) return decoded;
    if (decoded is num) return decoded != 0;
    if (decoded is String) return decoded.toLowerCase() == 'true';
    return false;
  }

  Future<bool> scrollToHighlight(String highlightId) async {
    MyLogger.info('[WebView] scrollToHighlight called for id: $highlightId');
    if (!_isLoaded) {
      MyLogger.warning('[WebView] Cannot scroll - WebView not loaded');
      return false;
    }

    final argsJson = jsonEncode({'id': highlightId});
    MyLogger.debug('[WebView] Executing JavaScript scroll command');

    try {
      final raw = await _controller.runJavaScriptReturningResult(
        '(function(){const args = $argsJson; const result = AnnotationEngine.scrollToHighlight(args.id); console.log("[Dart-Bridge] JS returned: " + result); return result;})();',
      );

      MyLogger.debug('[WebView] Raw JS return value: $raw');
      final decoded = _decodeJsValue(raw);
      MyLogger.info('[WebView] JavaScript returned: $raw, decoded: $decoded');

      if (decoded is bool) return decoded;
      if (decoded is num) return decoded != 0;
      if (decoded is String) return decoded.toLowerCase() == 'true';

      MyLogger.warning(
        '[WebView] Could not interpret scroll result as boolean',
      );
      return false;
    } catch (e) {
      MyLogger.error('[WebView] Error calling scrollToHighlight: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getHighlights() async {
    if (!_isLoaded) return const <Map<String, dynamic>>[];

    final raw = await _controller.runJavaScriptReturningResult(
      'JSON.stringify(AnnotationEngine.getHighlights());',
    );

    final decoded = _decodeJsValue(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map(
            (item) => item.map((key, value) => MapEntry(key.toString(), value)),
          )
          .toList();
    }

    return const <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>> searchText(String query) async {
    if (!_isLoaded) {
      debugPrint('[AnnotationWebView] searchText called but not loaded yet');
      return const {'total': 0, 'current': 0};
    }

    try {
      final result = await _controller.runJavaScriptReturningResult(
        'AnnotationEngine.searchText("${_escapeJavaScript(query)}")',
      );

      debugPrint('[AnnotationWebView] searchText raw result: $result');

      final decoded = _decodeJsValue(result);
      debugPrint('[AnnotationWebView] searchText decoded: $decoded');

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }

      return const {'total': 0, 'current': 0};
    } catch (e) {
      debugPrint('[AnnotationWebView] searchText error: $e');
      return const {'total': 0, 'current': 0};
    }
  }

  Future<Map<String, dynamic>> searchNext() async {
    if (!_isLoaded) return const {'total': 0, 'current': 0};

    try {
      final result = await _controller.runJavaScriptReturningResult(
        'AnnotationEngine.searchNext()',
      );

      debugPrint('[AnnotationWebView] searchNext result: $result');

      final decoded = _decodeJsValue(result);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }

      return const {'total': 0, 'current': 0};
    } catch (e) {
      debugPrint('[AnnotationWebView] searchNext error: $e');
      return const {'total': 0, 'current': 0};
    }
  }

  Future<Map<String, dynamic>> searchPrevious() async {
    if (!_isLoaded) return const {'total': 0, 'current': 0};

    try {
      final result = await _controller.runJavaScriptReturningResult(
        'AnnotationEngine.searchPrevious()',
      );

      debugPrint('[AnnotationWebView] searchPrevious result: $result');

      final decoded = _decodeJsValue(result);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }

      return const {'total': 0, 'current': 0};
    } catch (e) {
      debugPrint('[AnnotationWebView] searchPrevious error: $e');
      return const {'total': 0, 'current': 0};
    }
  }

  Future<void> clearSearch() async {
    if (!_isLoaded) return;
    await _controller.runJavaScript('AnnotationEngine.clearSearch();');
  }

  Future<void> clearCurrentSelection() async {
    if (!_isLoaded) return;
    await _controller.runJavaScript(
      'window.getSelection && window.getSelection().removeAllRanges();',
    );
  }

  Future<Map<String, dynamic>> getSearchStatus() async {
    if (!_isLoaded) {
      return const {'query': '', 'total': 0, 'current': 0, 'hasResults': false};
    }

    try {
      final result = await _controller.runJavaScriptReturningResult(
        'AnnotationEngine.getSearchStatus()',
      );

      final decoded = _decodeJsValue(result);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }

      return const {'query': '', 'total': 0, 'current': 0, 'hasResults': false};
    } catch (e) {
      debugPrint('[AnnotationWebView] getSearchStatus error: $e');
      return const {'query': '', 'total': 0, 'current': 0, 'hasResults': false};
    }
  }

  Future<void> setFontScale(double scale) async {
    if (!_isLoaded) return;
    await _controller.runJavaScript('AnnotationEngine.setFontScale($scale);');
  }

  Future<void> retypesetMath() async {
    if (!_isLoaded) return;
    await _controller.runJavaScript('AnnotationEngine.retypesetMath();');
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch URL: $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  String _escapeJavaScript(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoaded
        ? const PaperReadingShimmerLoading()
        : WebViewWidget(controller: _controller);
  }
}
