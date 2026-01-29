import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

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

  /// Build ImageProvider from XFile
  /// Returns appropriate image provider based on platform
  ImageProvider? buildImageProvider({
    required XFile? xFile,
    Uint8List? webImageBytes,
  }) {
    if (xFile == null) return null;

    if (kIsWeb) {
      if (webImageBytes == null) return null;
      return MemoryImage(webImageBytes);
    }

    return FileImage(File(xFile.path));
  }
}
