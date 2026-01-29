part of 'set_up_profile_cubit.dart';

class SetUpProfileState {
  final EducationLevel selectedEducationLevel;
  final bool isUnderGraduateSelected;
  final XFile? pickedImage;
  final Uint8List? pickedImageBytes;
  final bool isPickingImage;

  const SetUpProfileState({
    required this.selectedEducationLevel,
    required this.isUnderGraduateSelected,
    required this.pickedImage,
    required this.pickedImageBytes,
    required this.isPickingImage,
  });

  SetUpProfileState copyWith({
    EducationLevel? selectedEducationLevel,
    bool? isUnderGraduateSelected,
    XFile? pickedImage,
    Uint8List? pickedImageBytes,
    bool? isPickingImage,
  }) {
    return SetUpProfileState(
      selectedEducationLevel:
          selectedEducationLevel ?? this.selectedEducationLevel,
      isUnderGraduateSelected:
          isUnderGraduateSelected ?? this.isUnderGraduateSelected,
      pickedImage: pickedImage ?? this.pickedImage,
      pickedImageBytes: pickedImageBytes ?? this.pickedImageBytes,
      isPickingImage: isPickingImage ?? this.isPickingImage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SetUpProfileState &&
        other.selectedEducationLevel == selectedEducationLevel &&
        other.isUnderGraduateSelected == isUnderGraduateSelected &&
        other.pickedImage == pickedImage &&
        other.pickedImageBytes == pickedImageBytes &&
        other.isPickingImage == isPickingImage;
  }

  @override
  int get hashCode {
    return selectedEducationLevel.hashCode ^
        isUnderGraduateSelected.hashCode ^
        pickedImage.hashCode ^
        pickedImageBytes.hashCode ^
        isPickingImage.hashCode;
  }
}
