import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';

import '../cubit/chatbot_cubit.dart';
import 'animated_loading_status.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/chat_message.dart';
import 'image_preview_overlay.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  void _showImagePreview(
    BuildContext context,
    List<String> imagePaths,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (_) =>
          ImagePreviewOverlay(imagePaths: imagePaths, initialIndex: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImages =
        message.imagePaths != null && message.imagePaths!.isNotEmpty;

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
          // ================= IMAGES =================
          if (hasImages)
            Padding(
              padding: EdgeInsets.only(bottom: MySizes.spaceXs(context)),
              child: Wrap(
                spacing: MySizes.spaceXs(context),
                runSpacing: MySizes.spaceXs(context),
                children: List.generate(message.imagePaths!.length, (i) {
                  final path = message.imagePaths![i];

                  return GestureDetector(
                    onTap: () =>
                        _showImagePreview(context, message.imagePaths!, i),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(path),
                        width: 93,
                        height: 93,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),

          // ================= CHAT ROW =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (message.isUser)
                      _UserBubble(message: message)
                    else
                      _BotBubble(message: message),
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

/* ================= USER ================= */
class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onRetry;
  final VoidCallback? onEdit;

  const _UserBubble({required this.message, this.onRetry, this.onEdit});

  @override
  Widget build(BuildContext context) {
    if (message.text.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ================= MESSAGE =================
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MyColors.primaryShade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.text,
            style: context.bodyMedium.copyWith(
              color: MyColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // ================= ACTIONS =================
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // COPY
            IconButton(
              icon: HugeIcon(icon: HugeIconsStrokeRounded.copy01, size: 16),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message.text));
                MyLoaders.customToast(context: context, message: "Copied");
              },
            ),

            // EDIT
            // IconButton(
            //   icon: const Icon(Icons.edit, size: 16),
            //   onPressed:
            //       onEdit ??
            //       () {
            //         MyLoaders.customToast(
            //           context: context,
            //           message: "Edit not connected",
            //         );
            //       },
            // ),

            // // RETRY
            // IconButton(
            //   icon: const Icon(Icons.refresh, size: 16),
            //   onPressed:
            //       onRetry ??
            //       () {
            //         MyLoaders.customToast(
            //           context: context,
            //           message: "Retry not connected",
            //         );
            //       },
            // ),
          ],
        ),
      ],
    );
  }
}
/* ================= BOT ================= */

class _BotBubble extends StatelessWidget {
  final ChatMessage message;

  const _BotBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isStreaming = !message.isComplete && message.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ERROR
        if (message.isError)
          _ErrorBubble(message: message, context: context)
        // LOADING STATUS
        else if (message.loadingStatus != null && message.text.isEmpty)
          _LoadingStatusBubble(status: message.loadingStatus!, context: context)
        // TYPEWRITER STREAM
        else if (isStreaming)
          _TypewriterText(
            key: ValueKey(message.id),
            text: message.text,
            charactersPerSecond: 20,
            style: context.bodyMedium.copyWith(
              color: MyColors.textPrimary,
              height: 1.5,
              fontSize: 15,
            ),
          )
        // FINAL TEXT
        else if (message.text.isNotEmpty)
          MarkdownBody(data: message.text),

        // ================= ACTION ROW =================
        if (message.isComplete && message.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: HugeIcon(icon: HugeIconsStrokeRounded.copy01, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: message.text));
                    MyLoaders.customToast(context: context, message: "Copied");
                  },
                ),
                // Thumbs Up Button
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIconsStrokeRounded.thumbsUp,
                    size: 16,
                    color: message.userFeedback == 'THUMBS_UP'
                        ? MyColors.primaryButton
                        : MyColors.textSecondary,
                  ),
                  onPressed: message.isFeedbackSubmitting
                      ? null
                      : () {
                          if (message.userFeedback != 'THUMBS_UP') {
                            MyLoaders.customToast(
                              context: context,
                              message: "Submitting feedback...",
                            );
                            context.read<ChatbotCubit>().submitFeedback(
                              message.id,
                              'THUMBS_UP',
                            );
                          } else {
                            MyLoaders.customToast(
                              context: context,
                              message: "Feedback already submitted",
                            );
                          }
                        },
                ),
                // Thumbs Down Button
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIconsStrokeRounded.thumbsDown,
                    size: 16,
                    color: message.userFeedback == 'THUMBS_DOWN'
                        ? MyColors.primaryButton
                        : MyColors.textSecondary,
                  ),
                  onPressed: message.isFeedbackSubmitting
                      ? null
                      : () {
                          if (message.userFeedback != 'THUMBS_DOWN') {
                            MyLoaders.customToast(
                              context: context,
                              message: "Submitting feedback...",
                            );
                            context.read<ChatbotCubit>().submitFeedback(
                              message.id,
                              'THUMBS_DOWN',
                            );
                          } else {
                            MyLoaders.customToast(
                              context: context,
                              message: "Feedback already submitted",
                            );
                          }
                        },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/* ================= TYPEWRITER ================= */
class _TypewriterText extends StatefulWidget {
  final String text;
  final int charactersPerSecond;
  final TextStyle style;

  const _TypewriterText({
    super.key,
    required this.text,
    required this.charactersPerSecond,
    required this.style,
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  Timer? _timer;

  int _index = 0;
  String _buffer = '';

  late final int _interval;

  @override
  void initState() {
    super.initState();

    _interval = (1000 / widget.charactersPerSecond).clamp(16, 50).toInt();

    _buffer = widget.text;
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant _TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ONLY append new characters, don’t restart
    if (widget.text.length > _buffer.length) {
      final newPart = widget.text.substring(_buffer.length);
      _buffer = widget.text;

      _queueTyping(newPart);
    }
  }

  void _startTyping() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _interval), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_index < _buffer.length) {
        setState(() => _index++);
      } else {
        timer.cancel();
      }
    });
  }

  void _queueTyping(String newText) {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(milliseconds: _interval), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_index < _buffer.length) {
        setState(() => _index++);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _buffer.substring(0, _index.clamp(0, _buffer.length));

    return MarkdownBody(
      data: visible,
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context),
      ).copyWith(p: widget.style),
    );
  }
}
/* ================= LOADING ================= */

class _LoadingStatusBubble extends StatelessWidget {
  final String status;
  final BuildContext context;

  const _LoadingStatusBubble({required this.status, required this.context});

  @override
  Widget build(BuildContext context) {
    return AnimatedLoadingStatus(
      status: status,
      style: context.bodyMedium.copyWith(color: MyColors.primaryButton),
    );
  }
}

/* ================= ERROR ================= */

class _ErrorBubble extends StatelessWidget {
  final ChatMessage message;
  final BuildContext context;

  const _ErrorBubble({required this.message, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(message.text, style: const TextStyle(color: Colors.red)),
    );
  }
}
