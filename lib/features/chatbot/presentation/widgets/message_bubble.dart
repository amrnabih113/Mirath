import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.file(
                              File(message.imagePaths![index]),
                              width: ResponsiveHelper.responsiveValue(
                                context,
                                93,
                              ),
                              height: ResponsiveHelper.responsiveValue(
                                context,
                                93,
                              ),
                              fit: BoxFit.cover,
                            ),
                            if (message.isUser &&
                                message.uploadProgress != null)
                              Builder(
                                builder: (ctx) {
                                  final path = message.imagePaths![index];
                                  final prog =
                                      message.uploadProgress![path] ?? 0.0;
                                  if (prog <= 0.0 || prog >= 1.0)
                                    return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width:
                                              ResponsiveHelper.responsiveValue(
                                                context,
                                                93,
                                              ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: LinearProgressIndicator(
                                                  value: prog,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${(prog * 100).toStringAsFixed(0)}%',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              const SizedBox(width: 6),
                                              GestureDetector(
                                                onTap: () {
                                                  // cancel upload for this file
                                                  try {
                                                    // use Bloc to cancel
                                                    // ignore: avoid_dynamic_calls
                                                    final cubit = ctx
                                                        .read<ChatbotCubit>();
                                                    cubit.cancelUpload(path);
                                                  } catch (_) {}
                                                },
                                                child: Icon(
                                                  Icons.cancel_outlined,
                                                  size:
                                                      ResponsiveHelper.responsiveValue(
                                                        context,
                                                        16,
                                                      ),
                                                  color: MyColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
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
              if (message.isUser) ...[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (message.text.isNotEmpty)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
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
                                  ResponsiveHelper.responsiveValue(context, 18),
                                ),
                                topRight: Radius.circular(
                                  ResponsiveHelper.responsiveValue(context, 18),
                                ),
                                bottomLeft: Radius.circular(
                                  ResponsiveHelper.responsiveValue(context, 18),
                                ),
                                bottomRight: Radius.circular(
                                  ResponsiveHelper.responsiveValue(context, 4),
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
                    ],
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.isError)
                        _ErrorBubble(message: message, context: context)
                      else if (message.loadingStatus != null &&
                          message.loadingStatus!.isNotEmpty &&
                          message.text.isEmpty)
                        _LoadingStatusBubble(
                          status: message.loadingStatus!,
                          context: context,
                        )
                      else if (message.text.isNotEmpty)
                        _TypewriterText(
                          text: message.text,
                          isStreaming: !message.isComplete,
                          charactersPerSecond: 36,
                          style: context.bodyMedium.copyWith(
                            color: MyColors.textPrimary,
                            height: 1.5,
                            fontSize: ResponsiveHelper.responsiveValue(
                              context,
                              15,
                            ),
                          ),
                        ),
                      if (message.isComplete && message.text.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedCopy01,
                                size: ResponsiveHelper.responsiveValue(
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
                                Icons.thumb_up,
                                size: ResponsiveHelper.responsiveValue(
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
                                Icons.thumb_down,
                                size: ResponsiveHelper.responsiveValue(
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
                                icon: HugeIcons.strokeRoundedShare08,
                                size: ResponsiveHelper.responsiveValue(
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
                                size: ResponsiveHelper.responsiveValue(
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
            ],
          ),
        ],
      ),
    );
  }
}

class _TypewriterText extends StatefulWidget {
  final String text;
  final bool isStreaming;
  final int charactersPerSecond;
  final TextStyle style;

  const _TypewriterText({
    required this.text,
    required this.isStreaming,
    required this.charactersPerSecond,
    required this.style,
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  Timer? _timer;
  int _visibleCharacters = 0;
  String _lastTarget = '';
  late final int _intervalMs;

  @override
  void initState() {
    super.initState();
    _intervalMs = (1000 / widget.charactersPerSecond).round().clamp(16, 120);
    _syncTarget(force: true);
  }

  @override
  void didUpdateWidget(covariant _TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTarget();
  }

  void _syncTarget({bool force = false}) {
    final target = widget.text;
    final targetLength = target.length;

    // If target hasn't changed and we've shown all characters, no need to update
    if (!force && target == _lastTarget && _visibleCharacters >= targetLength) {
      return;
    }

    _lastTarget = target;

    if (widget.isStreaming) {
      // If timer is already running and text has new content, keep it running
      if (_timer != null && _timer!.isActive) {
        // Already streaming, just ensure visible characters don't exceed target
        if (_visibleCharacters > targetLength) {
          setState(() {
            _visibleCharacters = targetLength;
          });
        }
        return;
      }

      // Start or restart the typewriter animation
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: _intervalMs), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_visibleCharacters < widget.text.length) {
          setState(() {
            _visibleCharacters = (_visibleCharacters + 1).clamp(
              0,
              widget.text.length,
            );
          });
        } else {
          // All characters visible, keep timer running in case more arrive
          // (timer continues but won't update since _visibleCharacters is clamped)
        }
      });

      return;
    }

    // Not streaming - show all text immediately
    _timer?.cancel();
    if (_visibleCharacters != targetLength) {
      setState(() {
        _visibleCharacters = targetLength;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleText = widget.text.substring(
      0,
      _visibleCharacters.clamp(0, widget.text.length),
    );

    return MarkdownBody(
      data: visibleText,
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
      style: context.bodyMedium.copyWith(
        color: MyColors.primaryButton,
        height: 1.5,
        fontSize: ResponsiveHelper.responsiveValue(context, 15),
      ),
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
      padding: EdgeInsets.symmetric(
        horizontal: MySizes.spaceMd(context),
        vertical: MySizes.spaceSm(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 18),
        ),
        border: Border.all(
          color: const Color(0xFFEF5350).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                size: ResponsiveHelper.responsiveValue(context, 18),
                color: const Color(0xFFEF5350),
              ),
              SizedBox(width: MySizes.spaceXs(context)),
              Text(
                'Error',
                style: context.bodyMedium.copyWith(
                  color: const Color(0xFFEF5350),
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.responsiveValue(context, 14),
                ),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceXs(context)),
          Text(
            message.text,
            style: context.bodyMedium.copyWith(
              color: const Color(0xFFC62828),
              height: 1.5,
              fontSize: ResponsiveHelper.responsiveValue(context, 14),
            ),
          ),
        ],
      ),
    );
  }
}
