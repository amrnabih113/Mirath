import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController messageController;
  final List<XFile> selectedImages;
  final Function(AttachmentType) onPickAttachment;
  final VoidCallback onSendMessage;
  final VoidCallback onTextChanged;

  const ChatInputField({
    super.key,
    required this.messageController,
    required this.selectedImages,
    required this.onPickAttachment,
    required this.onSendMessage,
    required this.onTextChanged,
  });

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.responsiveValue(context, 20)),
        ),
      ),
      showDragHandle: false,
      builder: (context) => Padding(
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
                borderRadius: BorderRadius.circular(2),
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
                    onPickAttachment(AttachmentType.camera);
                  },
                ),
                _AttachmentOption(
                  icon: HugeIcons.strokeRoundedImage01,
                  label: S.of(context).attachment_photos,
                  onTap: () {
                    Navigator.pop(context);
                    onPickAttachment(AttachmentType.gallery);
                  },
                ),
                _AttachmentOption(
                  icon: HugeIcons.strokeRoundedAttachment,
                  label: S.of(context).attachment_files,
                  onTap: () {
                    Navigator.pop(context);
                    onPickAttachment(AttachmentType.document);
                  },
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceMd(context)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasContent =
        selectedImages.isNotEmpty || messageController.text.trim().isNotEmpty;

    return Padding(
      padding: MySizes.paddingSm(context),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: S.of(context).chat_message_hint,
                hintStyle: context.bodyMedium.copyWith(
                  color: MyColors.textSecondary,
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
                    Icons.mic,
                    color: MyColors.textSecondary,
                    size: ResponsiveHelper.responsiveValue(context, 20),
                  ),
                  onPressed: () {
                    // Voice input functionality
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.responsiveValue(context, 24),
                  ),
                  borderSide: BorderSide(color: MyColors.primaryShade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.responsiveValue(context, 24),
                  ),
                  borderSide: BorderSide(color: MyColors.primaryShade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.responsiveValue(context, 24),
                  ),
                  borderSide: BorderSide(
                    color: MyColors.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.responsiveValue(context, 12),
                  vertical: ResponsiveHelper.responsiveValue(context, 8),
                ),
              ),
              onSubmitted: hasContent ? (_) => onSendMessage() : null,
              onChanged: (_) => onTextChanged(),
            ),
          ),
          SizedBox(width: MySizes.spaceXs(context)),

          // Send button
          Container(
            decoration: BoxDecoration(
              color: hasContent
                  ? MyColors.primaryShade700
                  : MyColors.primaryShade700.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: MyColors.white,
                size: ResponsiveHelper.responsiveValue(context, 20),
              ),
              onPressed: hasContent ? onSendMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}

enum AttachmentType { gallery, camera, document }

class _AttachmentOption extends StatelessWidget {
  final List<List<dynamic>> icon;
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
            Text(label, style: context.bodyMedium),
          ],
        ),
      ),
    );
  }
}
