import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/my_colors.dart';
import '../utils/my_logger.dart';

/// Service for handling image picking operations
/// Abstracts image picker functionality for clean architecture
class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from gallery
  /// Returns [XFile] on success, null if cancelled or error occurs
  Future<XFile?> pickImageFromGallery({
    int imageQuality = 85,
    bool requestFullMetadata = false,
  }) async {
    try {
      MyLogger.info('[ImagePickerService] Opening image picker...');

      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        requestFullMetadata: requestFullMetadata,
      );

      if (image == null) {
        MyLogger.debug('[ImagePickerService] Image picker cancelled by user');
        return null;
      }

      MyLogger.info('[ImagePickerService] Image selected: ${image.name}');
      return image;
    } catch (e) {
      MyLogger.error('[ImagePickerService] Error picking image: $e');
      rethrow;
    }
  }

  /// Crop an image with customizable aspect ratio
  /// Returns [CroppedFile] on success, null if cancelled
  Future<CroppedFile?> cropImage({
    required String imagePath,
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
  }) async {
    try {
      MyLogger.info('[ImagePickerService] Opening image cropper...');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: aspectRatio,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: MyColors.primaryShade500,
            toolbarWidgetColor: MyColors.light,
            backgroundColor: MyColors.dark,
            activeControlsWidgetColor: MyColors.primaryShade500,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile == null) {
        MyLogger.debug('[ImagePickerService] Image cropping cancelled');
        return null;
      }

      MyLogger.info('[ImagePickerService] Image cropped successfully');
      return croppedFile;
    } catch (e) {
      MyLogger.error('[ImagePickerService] Error cropping image: $e');
      rethrow;
    }
  }

  /// Convert XFile image to bytes (useful for web platform)
  Future<Uint8List?> getImageBytes(XFile image) async {
    try {
      if (!kIsWeb) return null;

      MyLogger.debug('[ImagePickerService] Reading image bytes for web');
      return await image.readAsBytes();
    } catch (e) {
      MyLogger.error('[ImagePickerService] Error reading image bytes: $e');
      rethrow;
    }
  }

  /// Build ImageProvider from XFile or CroppedFile
  /// Returns appropriate image provider based on platform
  ImageProvider? buildImageProvider({
    XFile? xFile,
    CroppedFile? croppedFile,
    Uint8List? webImageBytes,
  }) {
    // Prioritize cropped file if available
    if (croppedFile != null) {
      if (kIsWeb) {
        // For web, we need to read bytes from CroppedFile
        // Note: This requires async, so for web cropped files,
        // consider using FutureBuilder or loading bytes beforehand
        return null; // Handle web case separately if needed
      }
      return FileImage(File(croppedFile.path));
    }

    if (xFile == null) return null;

    if (kIsWeb) {
      if (webImageBytes == null) return null;
      return MemoryImage(webImageBytes);
    }

    return FileImage(File(xFile.path));
  }
}
