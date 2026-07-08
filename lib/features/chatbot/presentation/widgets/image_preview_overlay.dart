import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_colors.dart';

class ImagePreviewOverlay extends StatefulWidget {
  final List<String>? imagePaths;
  final List<XFile>? images;
  final int initialIndex;

  const ImagePreviewOverlay({
    super.key,
    this.imagePaths,
    this.images,
    this.initialIndex = 0,
  }) : assert(
         imagePaths != null || images != null,
         'Either imagePaths or images must be provided',
       );

  @override
  State<ImagePreviewOverlay> createState() => _ImagePreviewOverlayState();
}

class _ImagePreviewOverlayState extends State<ImagePreviewOverlay> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalImages {
    if (widget.imagePaths != null) return widget.imagePaths!.length;
    return widget.images!.length;
  }

  Widget _buildImage(int index) {
    final String path;
    if (widget.imagePaths != null) {
      path = widget.imagePaths![index];
    } else {
      path = widget.images![index].path;
    }

    final uri = Uri.tryParse(path);
    final isRemote = uri != null && uri.hasScheme && uri.host.isNotEmpty;

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: isRemote
            ? Image.network(
                path,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                  size: 42,
                ),
              )
            : Image.file(File(path), fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.black,
      body: Stack(
        children: [
          // Image viewer with page navigation
          PageView.builder(
            controller: _pageController,
            itemCount: _totalImages,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) => _buildImage(index),
          ),

          // Close button
          SafeArea(
            child: Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCancel01,
                  color: MyColors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Image counter
          if (_totalImages > 1)
            SafeArea(
              child: Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / $_totalImages',
                      style: TextStyle(
                        color: MyColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Navigation arrows
          if (_totalImages > 1) ...[
            // Left arrow
            if (_currentIndex > 0)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: MyColors.white,
                      size: 36,
                    ),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),

            // Right arrow
            if (_currentIndex < _totalImages - 1)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      color: MyColors.white,
                      size: 36,
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
