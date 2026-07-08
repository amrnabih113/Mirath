import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/audio_recorder_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController messageController;
  final List<File> selectedFiles;
  final Function(InputAttachmentType) onPickAttachment;
  final VoidCallback onSendMessage;
  final VoidCallback onTextChanged;
  final Future<void> Function(File, int)? onVoiceRecorded;
  const ChatInputField({
    super.key,
    required this.messageController,
    required this.selectedFiles,
    required this.onPickAttachment,
    required this.onSendMessage,
    required this.onTextChanged,
    this.onVoiceRecorded,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final AudioRecorderService _recorder = sl<AudioRecorderService>();

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _timer;
  late final RecorderController _waveController;

  bool _isLocked = false;

  @override
  void initState() {
    super.initState();

    _waveController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  @override
  void dispose() {
    _waveController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.responsiveValue(context, 20)),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: MySizes.paddingMd(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveHelper.responsiveValue(context, 40),
                height: ResponsiveHelper.responsiveValue(context, 4),
                margin: EdgeInsets.only(bottom: MySizes.spaceMd(context)),
                decoration: BoxDecoration(
                  color: MyColors.primaryShade300,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentOption(
                    icon: HugeIcons.strokeRoundedCamera01,
                    label: S.of(context).attachment_camera,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onPickAttachment(InputAttachmentType.camera);
                    },
                  ),
                  _AttachmentOption(
                    icon: HugeIcons.strokeRoundedImage01,
                    label: S.of(context).attachment_photos,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onPickAttachment(InputAttachmentType.gallery);
                    },
                  ),
                  _AttachmentOption(
                    icon: HugeIcons.strokeRoundedAttachment,
                    label: S.of(context).attachment_files,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onPickAttachment(InputAttachmentType.document);
                    },
                  ),
                ],
              ),

              SizedBox(height: MySizes.spaceLg(context)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) return;

    final filename = 'chat_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.startRecording(filename);

    await _waveController.record();

    _timer?.cancel();

    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() => _recordSeconds++);
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();

    await _waveController.stop();

    final result = await _recorder.stopRecording();

    if (!mounted) return;

    setState(() {
      _isRecording = false;
    });

    if (result == null) return;

    await widget.onVoiceRecorded?.call(
      result['file'] as File,
      result['duration'] as int,
    );
  }

  Future<void> _cancelRecording() async {
    _timer?.cancel();

    await _waveController.stop();

    final result = await _recorder.stopRecording();

    if (result != null) {
      final file = result['file'] as File;

      if (await file.exists()) {
        await file.delete();
      }
    }

    if (!mounted) return;

    setState(() {
      _recordSeconds = 0;
      _isRecording = false;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasContent =
        widget.selectedFiles.isNotEmpty ||
        widget.messageController.text.trim().isNotEmpty;

    return Padding(
      padding: MySizes.paddingSm(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _isRecording
                      ? _RecordingInput(
                          key: const ValueKey("recording"),
                          controller: _waveController,
                          duration: _formatDuration(_recordSeconds),
                          onCancel: _cancelRecording,
                        )
                      : TextField(
                          key: const ValueKey("textfield"),
                          controller: widget.messageController,
                          minLines: 1,
                          maxLines: 6,
                          textInputAction: TextInputAction.newline,
                          onChanged: (_) => widget.onTextChanged(),
                          onSubmitted: hasContent
                              ? (_) => widget.onSendMessage()
                              : null,
                          decoration: InputDecoration(
                            hintText: S.of(context).chat_message_hint,

                            hintStyle: context.bodyMedium.copyWith(
                              color: MyColors.textSecondary,
                            ),

                            contentPadding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.responsiveValue(
                                context,
                                16,
                              ),
                              vertical: ResponsiveHelper.responsiveValue(
                                context,
                                12,
                              ),
                            ),

                            prefixIcon: IconButton(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedPlusSign,
                                color: MyColors.textSecondary,
                              ),
                              onPressed: () => _showAttachmentOptions(context),
                            ),

                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.mic_none_rounded,
                                color: MyColors.textSecondary,
                              ),
                              onPressed: _startRecording,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(
                                color: MyColors.primaryShade300,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(
                                color: MyColors.primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                ),
              ),

              SizedBox(width: MySizes.spaceSm(context)),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: hasContent || _isRecording
                      ? MyColors.primaryShade700
                      : MyColors.primaryShade700.withValues(alpha: .45),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    if (_isRecording) {
                      await _stopRecording();
                      widget.onSendMessage();
                    } else if (hasContent) {
                      widget.onSendMessage();
                    }
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isRecording ? HugeIconsStroke.stop : HugeIconsSolid.sent,
                      key: ValueKey(_isRecording),
                      color: MyColors.white,
                      size: ResponsiveHelper.responsiveValue(context, 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordingInput extends StatelessWidget {
  final RecorderController controller;
  final String duration;
  final VoidCallback onCancel;

  const _RecordingInput({
    super.key,
    required this.controller,
    required this.duration,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.primaryShade300),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: AudioWaveforms(
              recorderController: controller,
              enableGesture: false,
              size: const Size(double.infinity, 34),
              waveStyle: const WaveStyle(
                extendWaveform: true,
                showMiddleLine: false,
                spacing: 6,
                waveThickness: 3.5,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            duration,
            style: context.bodySmall.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(width: 12),

          InkWell(
            onTap: onCancel,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: MyColors.primaryShade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

enum InputAttachmentType { gallery, camera, document }

class _AttachmentOption extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.responsiveValue(context, 90),
        padding: MySizes.paddingMd(context),
        decoration: BoxDecoration(
          color: MyColors.primaryShade100,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: icon,
              color: MyColors.primaryColor,
              size: MySizes.iconMedium(context),
            ),

            SizedBox(height: MySizes.spaceXs(context)),

            Text(
              label,
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(
                color: MyColors.textPrimary,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
