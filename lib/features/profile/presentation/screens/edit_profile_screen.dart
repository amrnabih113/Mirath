import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/custum_text_button.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/generated/l10n.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _uiversityController = TextEditingController();
  final _currentPositionController = TextEditingController();
  final _countryController = TextEditingController();
  static const int maxLength = 150;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(),
        title: Text(S.of(context).username_label),
        centerTitle: true,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingLg(context),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: MySizes.borderRadiusLg(context) * 2,
                              child: SvgPicture.asset(
                                'assets/images/Profile picture (1).svg',
                              ),
                            ),
                            SizedBox(width: MySizes.spaceMd(context)),
                            CustumTextButton(
                              onTap: () {},
                              label: 'Edit picture',
                              color: MyColors.primaryShade50,
                              labelColor: MyColors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: MySizes.spaceXs(context)),
                        Text(S.of(context).name_field_label),
                        SizedBox(height: MySizes.spaceXs(context)),
                        TextFormField(
                          decoration: buildInputDecoration(),
                          cursorColor: MyColors.primaryColor,
                          controller: _nameController,
                          validator: (value) =>
                              MyValidator.validateEmail(context, value),
                          style: context.bodyMedium.copyWith(
                            color: MyColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceXs(context)),
                        Text(S.of(context).bio_field_label),
                        SizedBox(height: MySizes.spaceXs(context)),
                        Stack(
                          children: [
                            TextFormField(
                              controller: _bioController,
                              maxLength: maxLength,
                              maxLines: 3,
                              cursorColor: MyColors.primaryColor,
                              decoration: InputDecoration(
                                hintText: S.of(context).bio_hint,

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),

                                counterText: '',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: Text(
                                '(${_bioController.text.length}/$maxLength)',
                                style: context.bodySmall.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MySizes.spaceXs(context)),
                        Text(S.of(context).education_level_label),
                        SizedBox(height: MySizes.spaceXs(context)),
                        SizedBox(
                          width: MySizes.buttonWidth(context) * 1.75,
                          child: DropdownButtonFormField<String>(
                            //  initialValue: state.selectedEducationLevel.name,
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowDown01,
                              color: MyColors.primaryShade800,
                            ),
                            decoration: buildInputDecoration(),
                            hint: Text(
                              S.of(context).select_education_level,
                              style: context.bodyMedium,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: EducationLevel.highSchool.name,
                                child: Text(
                                  S.of(context).high_school,
                                  style: context.bodyMedium,
                                ),
                              ),
                              DropdownMenuItem(
                                value: EducationLevel.underGraduate.name,
                                child: Text(
                                  S.of(context).undergraduate,
                                  style: context.bodyMedium,
                                ),
                              ),
                              DropdownMenuItem(
                                value: EducationLevel.graduated.name,
                                child: Text(
                                  S.of(context).graduated,
                                  style: context.bodyMedium,
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              // if (value != null) {
                              //   final level = EducationLevel.values.firstWhere(
                              //     (e) => e.name == value,
                              //   );
                              //   context.read<SetUpProfileCubit>().updateEducationLevel(
                              //     level,
                              //   );
                              // }
                            },
                          ),
                        ),

                        SizedBox(height: MySizes.spaceXs(context)),
                        Text(S.of(context).university_label),
                        SizedBox(height: MySizes.spaceXs(context)),
                        TextFormField(
                          decoration: buildInputDecoration().copyWith(
                            hint: Text(S.of(context).university_hint),
                          ),
                          cursorColor: MyColors.primaryColor,
                          controller: _uiversityController,
                          validator: (value) =>
                              MyValidator.validateEmail(context, value),
                          style: context.bodyMedium.copyWith(
                            color: MyColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceXs(context)),
                        Text(S.of(context).position_label),
                        SizedBox(height: MySizes.spaceXs(context)),
                        TextFormField(
                          decoration: buildInputDecoration(),
                          cursorColor: MyColors.primaryColor,
                          controller: _currentPositionController,

                          validator: (value) =>
                              MyValidator.validateEmail(context, value),
                          style: context.bodyMedium.copyWith(
                            color: MyColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceXs(context)),
                        Text(S.of(context).country_label),
                        SizedBox(height: MySizes.spaceXs(context)),
                        TextFormField(
                          decoration: buildInputDecoration().copyWith(
                            hint: Text(S.of(context).country_hint),
                          ),
                          cursorColor: MyColors.primaryColor,
                          controller: _countryController,

                          validator: (value) =>
                              MyValidator.validateEmail(context, value),
                          style: context.bodyMedium.copyWith(
                            color: MyColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Keep email private',
                              style: context.bodySmall.copyWith(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: MySizes.spaceSm(context)),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                                activeThumbColor: MyColors.primaryShade800
                                    .withAlpha((255 * .5).toInt()),
                                thumbColor: WidgetStateProperty.all(
                                  MyColors.primaryShade50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Interests',
                              style: context.bodySmall.copyWith(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/edit_intersts_screen');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(S.of(context).edit_button),
                                  SizedBox(width: MySizes.spaceXs(context)),
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedPencilEdit01,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          runSpacing: MySizes.spaceSm(context),
                          children: [
                            TagChip(label: 'Physics'),
                            SizedBox(width: MySizes.spaceSm(context)),
                            TagChip(label: 'Physics'),
                            SizedBox(width: MySizes.spaceSm(context)),
                            TagChip(label: 'Physics'),
                            SizedBox(width: MySizes.spaceSm(context)),
                            TagChip(label: 'Physics'),
                            SizedBox(width: MySizes.spaceSm(context)),
                            TagChip(label: 'Physics'),
                            SizedBox(width: MySizes.spaceSm(context)),
                            TagChip(label: 'Physics'),
                          ],
                        ),
                        SizedBox(height: MySizes.spaceXl(context)),
                        Align(
                          alignment: AlignmentGeometry.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: MyColors.primaryShade800,
                            ),
                            child: Text(
                              'save changes',
                              style: context.bodySmall.copyWith(
                                color: MyColors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.primaryShade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.primaryShade900),
      ),
    );
  }
}
