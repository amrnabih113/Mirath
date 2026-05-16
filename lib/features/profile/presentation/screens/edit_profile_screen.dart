import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_enums.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_logger.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/constants/route_names.dart';

import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/tag_chip.dart';

import '../cubit/profile_cubit.dart';

import '../../../users/domain/entities/update_profile_data.dart';
import '../../../users/domain/entities/user.dart' as UserEnt;

import '../../../../generated/l10n.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _universityController = TextEditingController();
  final _countryController = TextEditingController();

  static const int maxBioLength = 150;

  final _imagePickerService = ImagePickerService();

  XFile? _pickedImage;

  bool _isPickingImage = false;
  bool _isInitialized = false;

  bool _keepEmailPrivate = false;

  EducationLevel? _selectedEducationLevel;
  List<String> _selectedInterests = [];

  UserEnt.User? _loadedUser(ProfileState state) {
    if (state is ProfileLoadSuccess) {
      return state.user;
    }

    if (state is ProfileUpdateSuccess) {
      return state.user;
    }

    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _universityController.dispose();
    _countryController.dispose();

    super.dispose();
  }

  void _initializeUserData(UserEnt.User user) {
    if (_isInitialized) return;

    _nameController.text = user.fullName;

    _bioController.text = user.bio ?? '';

    _universityController.text = user.university ?? '';

    _countryController.text = user.country ?? '';

    _keepEmailPrivate = !user.isEmailVisible;

    if (user.levelOfEducation.isNotEmpty) {
      _selectedEducationLevel = EducationLevel.values.firstWhere(
        (e) => e.name == user.levelOfEducation,
        orElse: () => EducationLevel.graduated,
      );
    }
    _selectedInterests = user.interests.map((e) => e.name).toList();
    _isInitialized = true;
  }

  Future<void> _pickAndCropImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      MyLogger.info('[EditProfile] Opening image picker...');

      final image = await _imagePickerService.pickImageFromGallery();

      if (image == null) {
        setState(() {
          _isPickingImage = false;
        });

        return;
      }

      final croppedFile = await _imagePickerService.cropImage(
        imagePath: image.path,
      );

      if (croppedFile == null) {
        setState(() {
          _isPickingImage = false;
        });

        return;
      }

      setState(() {
        _pickedImage = XFile(croppedFile.path);

        _isPickingImage = false;
      });
    } catch (e) {
      MyLogger.error('[EditProfile] Error: $e');

      setState(() {
        _isPickingImage = false;
      });

      MyLoaders.errorSnackBar(
        context: context,
        title: 'Error',
        message: 'Failed to pick image',
      );
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = UpdateProfileData(
      fullName: _nameController.text.trim(),
      bio: _bioController.text.trim(),

      country: _countryController.text.trim(),

      university: _selectedEducationLevel == EducationLevel.highSchool
          ? null
          : _universityController.text.trim(),

      profilePhoto: _pickedImage,
      interests: _selectedInterests,

      levelOfEducation: _selectedEducationLevel?.serverValue,

      keepEmailPrivate: _keepEmailPrivate,
    );

    context.read<ProfileCubit>().updateProfile(data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileUpdateSuccess) {
          MyLoaders.successSnackBar(
            context: context,
            title: "Success",
            message: "Profile updated successfully",
          );

          await Future.delayed(const Duration(milliseconds: 1200));

          if (context.mounted) {
            context.pop();
          }
        }

        if (state is ProfileFailure) {
          MyLoaders.errorSnackBar(
            context: context,
            title: "Error",
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        final user = _loadedUser(state);

        if (user != null) {
          _initializeUserData(user);
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: const MyBackIcon(),
            centerTitle: true,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: MySizes.paddingLg(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(user),

                      const SizedBox(height: 32),

                      _buildSectionCard(
                        children: [
                          buildTextField(
                            label: S.of(context).name_field_label,
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              }

                              return null;
                            },
                          ),

                          SizedBox(
                            height: ResponsiveHelper.responsiveValue(
                              context,
                              20,
                            ),
                          ),

                          buildTextField(
                            label: S.of(context).bio_field_label,
                            controller: _bioController,
                            maxLines: 4,
                            maxLength: maxBioLength,
                          ),

                          SizedBox(
                            height: ResponsiveHelper.responsiveValue(
                              context,
                              20,
                            ),
                          ),

                          _buildEducationDropdown(),

                          SizedBox(
                            height: ResponsiveHelper.responsiveValue(
                              context,
                              20,
                            ),
                          ),

                          if (_selectedEducationLevel !=
                              EducationLevel.highSchool) ...[
                            buildTextField(
                              label: S.of(context).university_label,
                              controller: _universityController,
                            ),

                            SizedBox(
                              height: ResponsiveHelper.responsiveValue(
                                context,
                                20,
                              ),
                            ),
                          ],

                          SizedBox(
                            height: ResponsiveHelper.responsiveValue(
                              context,
                              20,
                            ),
                          ),

                          buildTextField(
                            label: S.of(context).country_label,
                            controller: _countryController,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildPrivacySection(),

                      const SizedBox(height: 24),

                      _buildInterestsSection(user, _selectedInterests),

                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is ProfileUpdating
                              ? null
                              : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: MyColors.primaryShade800,
                            disabledBackgroundColor: MyColors.primaryShade800
                                .withOpacity(.7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: state is ProfileUpdating
                                ? const SizedBox(
                                    key: ValueKey('loading'),
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Save Changes',
                                    key: const ValueKey('text'),
                                    style: context.bodyMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserEnt.User? user) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: MyColors.primaryShade50,
                backgroundImage: _pickedImage != null
                    ? FileImage(File(_pickedImage!.path))
                    : (user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                              ? NetworkImage(user.photoUrl!)
                              : null)
                          as ImageProvider?,
                child:
                    (_pickedImage == null &&
                        (user?.photoUrl == null || user!.photoUrl!.isEmpty))
                    ? SvgPicture.asset('assets/images/Profile picture (1).svg')
                    : null,
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _isPickingImage ? null : _pickAndCropImage,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.primaryShade800,
                    ),
                    child: _isPickingImage
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            user?.fullName ?? '',
            style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text("@${user?.username ?? ''}", style: context.bodyMedium),
          const SizedBox(height: 6),
          Text(user?.email ?? '', style: context.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          cursorColor: MyColors.primaryColor,
          style: context.bodyMedium,
          decoration: buildInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildEducationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).education_level_label,
          style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<EducationLevel>(
          value: _selectedEducationLevel,
          decoration: buildInputDecoration(),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowDown01,
            color: MyColors.primaryShade800,
          ),
          items: EducationLevel.values.map((level) {
            return DropdownMenuItem(value: level, child: Text(level.name));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEducationLevel = value;

              if (value == EducationLevel.highSchool) {
                _universityController.clear();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return _buildSectionCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep email private',
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Hide your email from other users',
                    style: context.bodySmall.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Switch(
              value: _keepEmailPrivate,
              onChanged: (value) {
                setState(() {
                  _keepEmailPrivate = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsSection(
    UserEnt.User? user,
    List<String> selectedInterests,
  ) {
    final interestsToShow = selectedInterests.isNotEmpty
        ? selectedInterests
        : (user?.interests.map((e) => e.name).toList() ?? []);

    return _buildSectionCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Interests',
              style: context.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),

            TextButton(
              onPressed: () async {
                final result = await context.push<List<String>>(
                  RouteNames.editInterests,
                  extra: _selectedInterests.isNotEmpty
                      ? _selectedInterests
                      : (user?.interests.map((e) => e.name).toList() ?? []),
                );

                if (result != null) {
                  setState(() {
                    _selectedInterests = result;
                  });
                }
              },
              child: Row(
                children: [
                  Text(S.of(context).edit_button),
                  const SizedBox(width: 4),
                  HugeIcon(icon: HugeIcons.strokeRoundedEdit01, size: 16),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: interestsToShow.map((e) => TagChip(label: e)).toList(),
          ),
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: MyColors.primaryShade50.withAlpha(200),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: MyColors.primaryShade300),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: MyColors.primaryShade800,
          width: 1.5,
        ),
      ),
    );
  }
}
