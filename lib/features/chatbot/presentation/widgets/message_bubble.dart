import 'dart:io';

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
          // Images displayed in wrap above the bubble
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

          // Message bubble
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Avatar
              // if (!message.isUser) ...[
              //   Column(
              //     children: [
              //       SizedBox(height: MySizes.spaceSm(context)),
              //       Container(
              //         width: ResponsiveHelper.responsiveValue(context, 32),
              //         height: ResponsiveHelper.responsiveValue(context, 32),
              //         decoration: BoxDecoration(
              //           color: MyColors.primaryShade700,
              //           shape: BoxShape.circle,
              //         ),
              //         child: Icon(
              //           LucideIcons.bot,
              //           color: MyColors.white,
              //           size: ResponsiveHelper.responsiveValue(context, 18),
              //         ),
              //       ),
              //     ],
              //   ),
              //   SizedBox(width: MySizes.spaceSm(context)),
              // ],
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
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.text.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: MySizes.spaceSm(context),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                            ClipboardData(text: message.text),
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
