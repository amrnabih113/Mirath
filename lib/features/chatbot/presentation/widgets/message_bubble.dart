import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:mirath/features/chatbot/presentation/widgets/audio_message_bubble.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../data/models/chatbot_message_attachment.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chatbot_cubit.dart';
import 'animated_loading_status.dart';
import 'image_preview_overlay.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  void _showImagePreview(
    BuildContext context,
    List<String> sources,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (_) =>
          ImagePreviewOverlay(imagePaths: sources, initialIndex: index),
    );
  }

  List<String> get _imageSources {
    return message.attachments
        .where((attachment) => attachment.type == AttachmentType.image)
        .map(
          (attachment) => attachment.url?.isNotEmpty == true
              ? attachment.url!
              : attachment.localPath,
        )
        .whereType<String>()
        .toList();
  }

  List<MessageAttachment> get _audioAttachments {
    return message.attachments
        .where((attachment) => attachment.type == AttachmentType.audio)
        .toList();
  }

  Widget _buildAttachmentSummary(BuildContext context) {
    if (message.attachments.isEmpty) return const SizedBox.shrink();

    final images = _imageSources;
    final audios = _audioAttachments;

    return Column(
      crossAxisAlignment: message.isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty)
          Wrap(
            spacing: MySizes.spaceXs(context),
            runSpacing: MySizes.spaceXs(context),
            children: List.generate(images.length, (index) {
              final source = images[index];
              final uri = Uri.tryParse(source);
              final isRemote =
                  uri != null && uri.hasScheme && uri.host.isNotEmpty;

              return GestureDetector(
                onTap: () => _showImagePreview(context, images, index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isRemote
                      ? Image.network(
                          source,
                          width: 93,
                          height: 93,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(source),
                          width: 93,
                          height: 93,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            }),
          ),
        if (images.isNotEmpty && audios.isNotEmpty)
          SizedBox(height: MySizes.spaceXs(context)),
        if (audios.isNotEmpty)
          Column(
            children: audios
                .map(
                  (audio) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AudioMessageBubble(
                      isUser: message.isUser,

                      attachment: audio,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
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
          if (message.attachments.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: MySizes.spaceXs(context)),
              child: _buildAttachmentSummary(context),
            ),
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

class _UserBubble extends StatelessWidget {
  final ChatMessage message;

  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.text.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: HugeIcon(icon: HugeIconsStrokeRounded.copy01, size: 16),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message.text));
                MyLoaders.customToast(context: context, message: 'Copied');
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _BotBubble extends StatelessWidget {
  final ChatMessage message;

  const _BotBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isError)
          _ErrorBubble(message: message, context: context)
        else if (message.loadingStatus != null && message.text.isEmpty)
          _LoadingStatusBubble(status: message.loadingStatus!, context: context)
        else if (message.isNow == true && message.text.isNotEmpty)
          TypewriterText(
            text: message.text,
            style: context.bodyMedium.copyWith(
              color: MyColors.textPrimary,
              height: 1.5,
              fontSize: 15,
            ),
          )
        else if (message.text.isNotEmpty && message.isNow == false)
          MarkdownBody(data: message.text),
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
                    MyLoaders.customToast(context: context, message: 'Copied');
                  },
                ),
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
                            context.read<ChatbotCubit>().submitFeedback(
                              message.id,
                              'THUMBS_UP',
                            );
                            MyLoaders.customToast(
                              context: context,
                              message: 'Feedback submitted successfully',
                            );
                          } else {
                            MyLoaders.customToast(
                              context: context,
                              message: 'Feedback already submitted',
                            );
                          }
                        },
                ),
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
                              message: 'Submitting feedback...',
                            );
                            context.read<ChatbotCubit>().submitFeedback(
                              message.id,
                              'THUMBS_DOWN',
                            );
                          } else {
                            MyLoaders.customToast(
                              context: context,
                              message: 'Feedback already submitted',
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

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int charactersPerSecond;
  final VoidCallback? onFinished;

  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.charactersPerSecond = 20,
    this.onFinished,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;
  int _visibleCharacters = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      _visibleCharacters = 0;
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (widget.text.isEmpty) return;

    final interval = Duration(
      milliseconds: (1000 / widget.charactersPerSecond).round(),
    );

    _timer = Timer.periodic(interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_visibleCharacters < widget.text.length) {
        setState(() {
          _visibleCharacters++;
        });
      } else {
        timer.cancel();
        widget.onFinished?.call();
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
    final visible = widget.text.substring(
      0,
      _visibleCharacters.clamp(0, widget.text.length),
    );

    return MarkdownBody(
      data: visible,
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context),
      ).copyWith(p: widget.style),
    );
  }
}

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
