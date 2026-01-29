import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../../../core/utils/my_enums.dart';
import '../../../../core/utils/my_logger.dart';

part 'set_up_profile_state.dart';

class SetUpProfileCubit extends Cubit<SetUpProfileState> {
  final ImagePickerService _imagePickerService;

  SetUpProfileCubit({required ImagePickerService imagePickerService})
    : _imagePickerService = imagePickerService,
      super(
        const SetUpProfileState(
          selectedEducationLevel: EducationLevel.highSchool,
          isUnderGraduateSelected: false,
          pickedImage: null,
          pickedImageBytes: null,
          isPickingImage: false,
        ),
      );

  void updateEducationLevel(EducationLevel level) {
    final isUnderGraduate = level == EducationLevel.underGraduate;
    emit(
      state.copyWith(
        selectedEducationLevel: level,
        isUnderGraduateSelected: isUnderGraduate,
      ),
    );
    MyLogger.debug(
      'Updated Education Level: $level, IsUndergraduate: $isUnderGraduate',
    );
  }

  Future<void> pickImage() async {
    if (state.isPickingImage) return;
    emit(state.copyWith(isPickingImage: true));

    try {
      MyLogger.info('[SetUpProfile] Opening image picker...');

      // Pick image from gallery using the service
      final image = await _imagePickerService.pickImageFromGallery();

      if (image == null) {
        MyLogger.debug('[SetUpProfile] No image selected');
        emit(state.copyWith(isPickingImage: false));
        return;
      }

      MyLogger.info('[SetUpProfile] Image selected: ${image.name}');

      // Get image bytes for web platform
      final bytes = await _imagePickerService.getImageBytes(image);

      emit(
        state.copyWith(
          pickedImage: image,
          pickedImageBytes: bytes,
          isPickingImage: false,
        ),
      );

      MyLogger.info('[SetUpProfile] Image loaded successfully');
    } catch (e) {
      MyLogger.error('[SetUpProfile] Error picking image: $e');
      emit(state.copyWith(isPickingImage: false));
      rethrow;
    }
  }

  ImageProvider? buildAvatarImageProvider() {
    return _imagePickerService.buildImageProvider(
      xFile: state.pickedImage,
      webImageBytes: state.pickedImageBytes,
    );
  }
}
