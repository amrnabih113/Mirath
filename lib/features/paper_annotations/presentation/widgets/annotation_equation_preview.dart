import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class AnnotationEquationPreview extends StatelessWidget {
  final String text;
  final String? htmlContent;
  final String? highlightColorHex;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow overflow;

  const AnnotationEquationPreview({
    super.key,
    required this.text,
    this.htmlContent,
    this.highlightColorHex,
    this.textStyle,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  static final RegExp _latexPattern = RegExp(
    r'\$\$([\s\S]+?)\$\$|\$([^$]+?)\$|\\\(([\s\S]+?)\\\)|\\\[([\s\S]+?)\\\]',
    multiLine: true,
  );

  bool _containsMathHints(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;

    final hintPattern = RegExp(
      r'\\(frac|sum|int|sqrt|alpha|beta|gamma|theta|pi|sigma|lambda|mu|nu|phi|psi|omega|cdot|times|pm|leq|geq)',
      caseSensitive: false,
    );

    final htmlHints = RegExp(
      r'<math|mjx-container|katex|ltx_Math|data-math|mathjax',
      caseSensitive: false,
    );

    return _latexPattern.hasMatch(trimmed) ||
        hintPattern.hasMatch(trimmed) ||
        htmlHints.hasMatch(trimmed);
  }

  String _bestContent() {
    if (_latexPattern.hasMatch(text)) return text;
    final html = htmlContent;
    if (html != null && _latexPattern.hasMatch(html)) {
      return html;
    }
    return text;
  }

  Color? _highlightBackground() {
    if (highlightColorHex == null) return null;
    final clean = highlightColorHex!.replaceAll('#', '');
    if (clean.length != 6 && clean.length != 8) return null;
    final argb = clean.length == 6 ? 'FF$clean' : clean;
    return Color(int.parse(argb, radix: 16)).withValues(alpha: 0.45);
  }

  List<InlineSpan> _buildMathSpans(String value, TextStyle effectiveStyle) {
    final spans = <InlineSpan>[];
    int lastIndex = 0;

    for (final match in _latexPattern.allMatches(value)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: value.substring(lastIndex, match.start)));
      }

      final displayMath = match.group(1) ?? match.group(4);
      final inlineMath = match.group(2) ?? match.group(3);
      final isDisplay = displayMath != null;
      final mathSource = (displayMath ?? inlineMath ?? '').trim();

      if (mathSource.isEmpty) {
        lastIndex = match.end;
        continue;
      }

      try {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: isDisplay ? 4 : 0),
              child: Math.tex(
                mathSource,
                mathStyle: isDisplay ? MathStyle.display : MathStyle.text,
                textStyle: effectiveStyle,
                options: MathOptions(
                  fontSize: effectiveStyle.fontSize ?? 14,
                  color: effectiveStyle.color ?? Colors.black,
                ),
              ),
            ),
          ),
        );
      } catch (_) {
        spans.add(TextSpan(text: match.group(0)));
      }

      lastIndex = match.end;
    }

    if (lastIndex < value.length) {
      spans.add(TextSpan(text: value.substring(lastIndex)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium;
    if (effectiveStyle == null) return const SizedBox.shrink();

    final content = _bestContent();
    final hasLatex = _latexPattern.hasMatch(content);
    final isEquationLike = _containsMathHints(content);

    if (hasLatex) {
      final spans = _buildMathSpans(content, effectiveStyle);
      return RichText(
        maxLines: maxLines,
        overflow: overflow,
        text: TextSpan(style: effectiveStyle, children: spans),
      );
    }

    return Text(
      content,
      maxLines: maxLines,
      overflow: overflow,
      style: effectiveStyle.copyWith(
        backgroundColor: isEquationLike ? null : _highlightBackground(),
      ),
    );
  }
}
