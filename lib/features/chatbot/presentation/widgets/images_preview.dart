import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import 'image_preview_overlay.dart';

class ImagesPreview extends StatelessWidget {
final List<File> selectedFiles;
  final Function(int) onRemoveImage;

  const ImagesPreview({
    super.key,
    required this.selectedFiles,
    required this.onRemoveImage,
  });

  void _showImagePreview(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => ImagePreviewOverlay(
        images: selectedFiles.map((file) => XFile(file.path)).toList(),
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveValue(context, 80),
      padding: EdgeInsets.symmetric(
        horizontal: MySizes.spaceMd(context),
        vertical: MySizes.spaceSm(context),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: selectedFiles.length,
        separatorBuilder: (_, __) => SizedBox(width: MySizes.spaceSm(context)),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _showImagePreview(context, index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.responsiveValue(context, 8),
                  ),
                  child: Image.file(
                    selectedFiles[index],
                    width: ResponsiveHelper.responsiveValue(context, 60),
                    height: ResponsiveHelper.responsiveValue(context, 60),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemoveImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: MyColors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      size: 16,
                      color: MyColors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
