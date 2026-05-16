import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

import '../../domain/entities/chat_message.dart';
import 'image_preview_overlay.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  void _showImagePreview(
    BuildContext context,
    List<String> imagePaths,
    int initialIndex,
  ) {
    showDialog(
      context: context,
      builder: (context) => ImagePreviewOverlay(
        imagePaths: imagePaths,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTyping = message.id == 'typing';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MySizes.spaceSm(context),
        left: message.isUser ? MySizes.spaceLg(context) : 0,
        right: message.isUser ? 0 : MySizes.spaceLg(context),
      ),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.imagePaths != null && message.imagePaths!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: MySizes.spaceXs(context)),
              child: Wrap(
                spacing: MySizes.spaceXs(context),
                runSpacing: MySizes.spaceXs(context),
                children: List.generate(
                  message.imagePaths!.length,
                  (index) => GestureDetector(
                    onTap: () =>
                        _showImagePreview(context, message.imagePaths!, index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.primaryShade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.responsiveValue(context, 8),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.responsiveValue(context, 7),
                        ),
                        child: Image.file(
                          File(message.imagePaths![index]),
                          width: ResponsiveHelper.responsiveValue(context, 93),
                          height: ResponsiveHelper.responsiveValue(context, 93),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message.isUser
                  ? Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (message.text.isNotEmpty)
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MySizes.spaceMd(context),
                                  vertical: MySizes.spaceSm(context),
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.primaryShade100,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      ResponsiveHelper.responsiveValue(
                                        context,
                                        18,
                                      ),
                                    ),
                                    topRight: Radius.circular(
                                      ResponsiveHelper.responsiveValue(
                                        context,
                                        18,
                                      ),
                                    ),
                                    bottomLeft: Radius.circular(
                                      ResponsiveHelper.responsiveValue(
                                        context,
                                        18,
                                      ),
                                    ),
                                    bottomRight: Radius.circular(
                                      ResponsiveHelper.responsiveValue(
                                        context,
                                        4,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  message.text,
                                  style: context.bodyMedium.copyWith(
                                    color: MyColors.textPrimary,
                                    height: 1.5,
                                    fontSize: ResponsiveHelper.responsiveValue(
                                      context,
                                      15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (message.text.isNotEmpty)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  ResponsiveHelper.responsiveValue(
                                    context,
                                    -10,
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: _BubbleTailPainter(
                                    color: MyColors.primaryShade100,
                                  ),
                                  size: Size(
                                    ResponsiveHelper.responsiveValue(
                                      context,
                                      10,
                                    ),
                                    ResponsiveHelper.responsiveValue(
                                      context,
                                      10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Pending indicator for user's outgoing messages
                          if (message.isUser && message.isPending)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sending...',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.text.isNotEmpty || isTyping)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: MySizes.spaceSm(context),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isTyping)
                                    const _TypingIndicator()
                                  else ...[
                                    MarkdownBody(
                                      data: message.text,
                                      styleSheet:
                                          MarkdownStyleSheet.fromTheme(
                                            Theme.of(context),
                                          ).copyWith(
                                            p: context.bodyMedium.copyWith(
                                              color: MyColors.textPrimary,
                                              height: 1.5,
                                              fontSize:
                                                  ResponsiveHelper.responsiveValue(
                                                    context,
                                                    15,
                                                  ),
                                            ),
                                            h1: context.headlineSmall.copyWith(
                                              color: MyColors.textPrimary,
                                            ),
                                            h2: context.titleLarge.copyWith(
                                              color: MyColors.textPrimary,
                                            ),
                                            h3: context.titleMedium.copyWith(
                                              color: MyColors.textPrimary,
                                            ),
                                            strong: context.bodyMedium.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: MyColors.textPrimary,
                                            ),
                                            em: context.bodyMedium.copyWith(
                                              fontStyle: FontStyle.italic,
                                              color: MyColors.textPrimary,
                                            ),
                                            blockquote: context.bodyMedium
                                                .copyWith(
                                                  color: MyColors.textSecondary,
                                                ),
                                            code: context.bodyMedium.copyWith(
                                              fontFamily: 'monospace',
                                              color: MyColors.textPrimary,
                                            ),
                                            listBullet: context.bodyMedium
                                                .copyWith(
                                                  color: MyColors.textPrimary,
                                                ),
                                          ),
                                    ),
                                    if (message.isComplete)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              LucideIcons.copy,
                                              size:
                                                  ResponsiveHelper.responsiveValue(
                                                    context,
                                                    16,
                                                  ),
                                              color: MyColors.textSecondary,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text: message.text,
                                                ),
                                              );
                                              MyLoaders.customToast(
                                                context: context,
                                                message: 'Copied to clipboard',
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              LucideIcons.thumbsUp,
                                              size:
                                                  ResponsiveHelper.responsiveValue(
                                                    context,
                                                    16,
                                                  ),
                                              color: MyColors.textSecondary,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              LucideIcons.thumbsDown,
                                              size:
                                                  ResponsiveHelper.responsiveValue(
                                                    context,
                                                    16,
                                                  ),
                                              color: MyColors.textSecondary,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              LucideIcons.share2,
                                              size:
                                                  ResponsiveHelper.responsiveValue(
                                                    context,
                                                    16,
                                                  ),
                                              color: MyColors.textSecondary,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedMoreHorizontalCircle01,
                                              size:
                                                  ResponsiveHelper.responsiveValue(
                                                    context,
                                                    16,
                                                  ),
                                              color: MyColors.textSecondary,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;

  _BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotOpacity(int index) {
    final phase = (_controller.value + (index * 0.2)) % 1.0;
    return 0.3 + 0.7 * (0.5 + 0.5 * math.sin(2 * math.pi * phase));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Opacity(
                opacity: _dotOpacity(index),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: MyColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
