import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import '../../../auth/data/models/auth_user_data.dart';
import '../../domain/entities/profile_setup_data.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_enums.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_logger.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../../../common/widgets/text_feild_with_lable.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SetUpProfileScreen extends StatefulWidget {
  const SetUpProfileScreen({super.key, required this.user});
  final AuthUserData user;
  @override
  State<SetUpProfileScreen> createState() => _SetUpProfileScreenState();
}

class _SetUpProfileScreenState extends State<SetUpProfileScreen> {
  EducationLevel selectedEducationLevel = EducationLevel.highSchool;
  bool isUnderGraduateSelected = false;

  final LocalStorageService _localStorageService = sl<LocalStorageService>();

  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    selectedEducationLevel = EducationLevel.highSchool;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MySizes.spaceMd(context)),
            child: IconButton(
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(S.of(context).sign_out),
                      content: Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<AuthCubit>().signOut();
                          },
                          child: Text('Sign Out'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.logout,
                color: MyColors.primaryShade700,
                size: MySizes.iconMedium(context),
              ),
              tooltip: 'Sign Out',
            ),
          ),
        ],
      ),

      body: ScreenDecoration(
        dark: false,
        child: Padding(
          padding: MySizes.paddingLg(context),
          child: SafeArea(
            bottom: false,
            minimum: EdgeInsets.zero,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.error) {
                      MyLoaders.errorSnackBar(
                        context: context,
                        title: "Oh no! ",
                        message:
                            state.message ?? S.of(context).something_went_wrong,
                      );
                    } else if (state.status == AuthStatus.success) {
                      MyLoaders.successSnackBar(
                        context: context,
                        title: "Success! ",
                        message:
                            state.message ??
                            S.of(context).profile_setup_success,
                      );
                      _localStorageService.setProfileSetup(true);
                      context.go('/home');
                    }
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).set_up_profile,
                              style: context.displayMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.sourceSans3(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            SizedBox(height: MySizes.spaceLg(context)),
                            Container(
                              width: constraints.maxWidth,

                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: MyColors.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0xFFA6A29E),
                                    blurRadius: 32,
                                    offset: Offset(0, 16),
                                    spreadRadius: -16,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: MySizes.paddingMd(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Picture Placeholder
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius:
                                              MySizes.iconLarge(context) * 1.3,
                                          backgroundColor:
                                              MyColors.primaryShade100,
                                          child: HugeIcon(
                                            icon:
                                                HugeIcons.strokeRoundedCamera01,
                                            size:
                                                MySizes.iconLarge(context) *
                                                1.3,
                                            color: MyColors.primaryShade700,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MySizes.spaceSm(context),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            padding: MySizes.paddingMd(context),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                S.of(context).upload_picture,
                                              ),
                                              SizedBox(
                                                width: MySizes.spaceSm(context),
                                              ),
                                              Icon(
                                                Iconsax.add,
                                                size: MySizes.iconSmall(
                                                  context,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: MySizes.spaceLg(context)),
                                    TextFeildWithLable(
                                      label: S.of(context).name,
                                      hintText: S.of(context).enter_your_name,
                                      controller: _nameController,
                                    ),
                                    SizedBox(height: MySizes.spaceSm(context)),
                                    TextFeildWithLable(
                                      label: S.of(context).username,
                                      readOnly: true,
                                      hintText: S.of(context).choose_username,
                                      controller: _usernameController,
                                    ),
                                    SizedBox(height: MySizes.spaceSm(context)),
                                    TextFeildWithLable(
                                      label: S.of(context).email,
                                      readOnly: true,
                                      hintText: S.of(context).enter_your_email,
                                      controller: _emailController,
                                    ),
                                    SizedBox(height: MySizes.spaceSm(context)),
                                    Text(
                                      S.of(context).education_level,
                                      style: context.bodyLarge,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: MySizes.spaceXs(context)),
                                    DropdownButtonFormField<String>(
                                      initialValue: selectedEducationLevel.name,
                                      hint: Text(
                                        S.of(context).select_education_level,
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: EducationLevel.highSchool.name,
                                          child: Text(
                                            S.of(context).high_school,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              EducationLevel.underGraduate.name,
                                          child: Text(
                                            S.of(context).undergraduate,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: EducationLevel.graduated.name,
                                          child: Text(S.of(context).graduated),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedEducationLevel =
                                              EducationLevel.values.firstWhere(
                                                (e) => e.name == value,
                                              );
                                          isUnderGraduateSelected =
                                              selectedEducationLevel ==
                                              EducationLevel.underGraduate;
                                        });
                                        MyLogger.debug(
                                          'Selected Education Level: $selectedEducationLevel'
                                          'Is Undergraduate Selected: $isUnderGraduateSelected',
                                        );
                                      },
                                    ),
                                    if (isUnderGraduateSelected) ...[
                                      SizedBox(
                                        height: MySizes.spaceSm(context),
                                      ),
                                      TextFeildWithLable(
                                        label: S.of(context).university_name,
                                        hintText: S
                                            .of(context)
                                            .enter_university_name,
                                        controller: _universityController,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: MySizes.spaceLg(context)),
                            SizedBox(
                              width: MySizes.buttonWidth(context),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add basic validation
                                  if (_nameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter your name'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (isUnderGraduateSelected &&
                                      (_universityController.text.isEmpty ||
                                          _universityController.text.length <
                                              2)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter a valid university name (at least 2 characters)',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final userProfile = ProfileSetupData(
                                    name: _nameController.text,
                                    levelOfEducation:
                                        selectedEducationLevel.serverValue,
                                    interests: [],
                                    university:
                                        _universityController.text.isEmpty
                                        ? null
                                        : _universityController.text,
                                  );
                                  context.push(
                                    '/interests',
                                    extra: userProfile,
                                  );
                                },
                                child: Text(
                                  S.of(context).next,
                                  style: context.titleMedium.copyWith(
                                    color: MyColors.light,
                                    fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
