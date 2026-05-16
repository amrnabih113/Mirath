import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/my_colors.dart';

/// Native Flutter LaTeX renderer using flutter_math_fork
/// Supports inline math ($...$) and display math ($$...$$)
/// Optimized for scrolling performance
class LaTeXRenderer extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final double? height;
  final double? width;

  const LaTeXRenderer({
    super.key,
    required this.text,
    this.textStyle,
    this.height,
    this.width,
  });

  @override
  State<LaTeXRenderer> createState() => _LaTeXRendererState();
}

class _LaTeXRendererState extends State<LaTeXRenderer> {
  bool _isLoading = true;
  List<InlineSpan> _parsedSpans = [];

  @override
  void initState() {
    super.initState();
    _parseText();
  }

  @override
  void didUpdateWidget(LaTeXRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.textStyle != widget.textStyle) {
      setState(() => _isLoading = true);
      _parseText();
    }
  }

  /// Parse text and split into text/math segments
  void _parseText() {
    Future.microtask(() {
      final spans = <InlineSpan>[];
      final textStyle = widget.textStyle ?? const TextStyle(fontSize: 16);

      // Split by inline math $...$ and display math $$...$$
      final regex = RegExp(r'\$\$([^\$]+?)\$\$|\$([^\$]+?)\$');
      int lastIndex = 0;

      for (final match in regex.allMatches(widget.text)) {
        // Add text before math
        if (match.start > lastIndex) {
          final textPart = widget.text.substring(lastIndex, match.start);
          spans.add(TextSpan(text: textPart, style: textStyle));
        }

        // Add math part
        final isDisplayMode = match.group(1) != null;
        final mathContent = match.group(1) ?? match.group(2) ?? '';

        try {
          final mathWidget = Math.tex(
            mathContent,
            textStyle: textStyle.copyWith(fontSize: textStyle.fontSize ?? 16),
            mathStyle: isDisplayMode ? MathStyle.display : MathStyle.text,
            options: MathOptions(
              fontSize: textStyle.fontSize ?? 16,
              color: textStyle.color ?? Colors.black,
            ),
          );

          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: isDisplayMode
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: mathWidget,
                    )
                  : mathWidget,
            ),
          );
        } catch (e) {
          // Fallback: show raw LaTeX if parsing fails
          spans.add(
            TextSpan(
              text: '\$$mathContent\$',
              style: textStyle.copyWith(
                fontFamily: 'monospace',
                backgroundColor: MyColors.primaryShade50,
              ),
            ),
          );
        }

        lastIndex = match.end;
      }

      // Add remaining text
      if (lastIndex < widget.text.length) {
        final remainingText = widget.text.substring(lastIndex);
        spans.add(TextSpan(text: remainingText, style: textStyle));
      }

      if (mounted) {
        setState(() {
          _parsedSpans = spans;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 100,
        child: Shimmer.fromColors(
          baseColor: MyColors.primaryShade50,
          highlightColor: MyColors.white,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                10,
                (index) => Container(
                  height: 14,
                  width: index % 3 == 0
                      ? double.infinity * 0.6
                      : double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width ?? double.infinity,
      child: RichText(text: TextSpan(children: _parsedSpans)),
    );
  }
}
