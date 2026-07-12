import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import 'chat_input_field.dart';
import 'images_preview.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController messageController;

  final List<File> selectedFiles;

  final Function(InputAttachmentType) onPickAttachment;

  final VoidCallback onSendMessage;

  final Function(int) onRemoveImage;

  final VoidCallback onTextChanged;

  final Future<void> Function(File, int)? onVoiceRecorded;

  const ChatInputArea({
    super.key,
    required this.messageController,
    required this.selectedFiles,
    required this.onPickAttachment,
    required this.onSendMessage,
    required this.onRemoveImage,
    required this.onTextChanged,
    this.onVoiceRecorded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: MyColors.white,
        boxShadow: [
          BoxShadow(
            color: MyColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (selectedFiles.isNotEmpty)
            ImagesPreview(
              selectedFiles: selectedFiles,
              onRemoveImage: onRemoveImage,
            ),

          ChatInputField(
            messageController: messageController,
            selectedFiles: selectedFiles,
            onPickAttachment: onPickAttachment,
            onSendMessage: onSendMessage,
            onTextChanged: onTextChanged,
            onVoiceRecorded: onVoiceRecorded,
          ),
        ],
      ),
    );
  }
}
