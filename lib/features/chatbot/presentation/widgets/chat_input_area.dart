import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/my_colors.dart';
import 'chat_input_field.dart';
import 'images_preview.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController messageController;
  final List<XFile> selectedImages;
  final Function(AttachmentType) onPickAttachment;
  final VoidCallback onSendMessage;
  final Function(int) onRemoveImage;
  final VoidCallback onTextChanged;

  const ChatInputArea({
    super.key,
    required this.messageController,
    required this.selectedImages,
    required this.onPickAttachment,
    required this.onSendMessage,
    required this.onRemoveImage,
    required this.onTextChanged,
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
          // Selected images preview
          if (selectedImages.isNotEmpty)
            ImagesPreview(
              selectedImages: selectedImages,
              onRemoveImage: onRemoveImage,
            ),

          // Input field
          ChatInputField(
            messageController: messageController,
            selectedImages: selectedImages,
            onPickAttachment: onPickAttachment,
            onSendMessage: onSendMessage,
            onTextChanged: onTextChanged,
          ),
        ],
      ),
    );
  }
}
