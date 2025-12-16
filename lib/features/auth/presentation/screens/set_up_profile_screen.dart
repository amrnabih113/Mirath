import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_enums.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_logger.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../../../common/widgets/text_feild_with_lable.dart';
import '../../domain/entities/user_profile.dart';
import '../cubit/auth_cubit.dart';

class SetUpProfileScreen extends StatefulWidget {
  const SetUpProfileScreen({super.key, required this.userEntity});
  final UserEntity userEntity;
  @override
  State<SetUpProfileScreen> createState() => _SetUpProfileScreenState();
}

// temporary user entity for testing untill the backend gives real data
class UserEntity {
  final String? name;
  final String? imageUrl;
  final String username;
  final String email;
  final EducationLevel? educationLevel;
  final String? university;

  UserEntity({
    this.name,
    this.educationLevel,
    this.imageUrl,
    required this.username,
    required this.email,
    this.university,
  });
}

class _SetUpProfileScreenState extends State<SetUpProfileScreen> {
  EducationLevel selectedEducationLevel = EducationLevel.none;
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
    _usernameController.text = widget.userEntity.username;
    _emailController.text = widget.userEntity.email;
    _nameController.text = widget.userEntity.name ?? '';
    _universityController.text = widget.userEntity.university ?? '';
    selectedEducationLevel =
        widget.userEntity.educationLevel ?? EducationLevel.none;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  void _handleSkip() {
    _localStorageService.setProfileSetup(true);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: MySizes.iconLarge(context) * 2,
        toolbarHeight: MySizes.iconLarge(context),
        leading: TextButton(
          onPressed: _handleSkip,
          child: Text('Skip', style: context.bodyMedium),
        ),
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
                        message: state.message ?? 'An unknown error occurred.',
                      );
                    } else if (state.status == AuthStatus.success) {
                      MyLoaders.successSnackBar(
                        context: context,
                        title: "Success! ",
                        message:
                            state.message ?? 'Profile set up successfully.',
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
                              'Set Up Your Profile',
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
                                color: MyColors.cardColor /* Card-color */,
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
                                              Text("Upload Picture"),
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
                                      label: "Name",
                                      hintText: "Enter your name",
                                      controller: _nameController,
                                    ),
                                    SizedBox(height: MySizes.spaceSm(context)),
                                    TextFeildWithLable(
                                      label: "Username",
                                      hintText: "Choose a username",
                                      controller: _usernameController,
                                    ),
                                    SizedBox(height: MySizes.spaceSm(context)),
                                    TextFeildWithLable(
                                      label: "Email",
                                      hintText: "Enter your email",
                                      controller: _emailController,
                                    ),
                                    SizedBox(height: MySizes.spaceSm(context)),
                                    Text(
                                      "Education Level",
                                      style: context.bodyLarge,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: MySizes.spaceXs(context)),
                                    DropdownButtonFormField<String>(
                                      hint: Text("Select your education level"),
                                      items: [
                                        DropdownMenuItem(
                                          value: EducationLevel.highSchool.name,
                                          child: Text("High School"),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              EducationLevel.underGraduate.name,
                                          child: Text("Undergraduate"),
                                        ),
                                        DropdownMenuItem(
                                          value: EducationLevel.graduated.name,
                                          child: Text("Graduated"),
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
                                        label: "University Name",
                                        hintText: "Enter your university name",
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: MySizes.spaceLg(context)),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading =
                                    state.status == AuthStatus.loading;
                                return SizedBox(
                                  width: MySizes.buttonWidth(context),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<AuthCubit>().setUpProfile(
                                        UserProfile(
                                          username: _usernameController.text,
                                          email: _emailController.text,
                                          educationLevel:
                                              selectedEducationLevel,
                                        ),
                                      );
                                    },

                                    child: isLoading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    MyColors.primaryShade50,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            'Next',
                                            style: context.titleMedium.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                  ),
                                );
                              },
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
