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
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../../../common/widgets/text_feild_with_lable.dart';
import '../../domain/entities/profile_setup_data.dart';
import '../cubit/set_up_profile_cubit.dart';

class SetUpProfileScreen extends StatelessWidget {
  const SetUpProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SetUpProfileCubit>(),
      child: const _SetUpProfileScreenContent(),
    );
  }
}

class _SetUpProfileScreenContent extends StatefulWidget {
  const _SetUpProfileScreenContent();

  @override
  State<_SetUpProfileScreenContent> createState() =>
      _SetUpProfileScreenContentState();
}

class _SetUpProfileScreenContentState
    extends State<_SetUpProfileScreenContent> {
  late TextEditingController _nameController;
  late TextEditingController _universityController;
  final LocalStorageService _localStorageService = sl<LocalStorageService>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _universityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetUpProfileCubit, SetUpProfileState>(
      builder: (context, state) {
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
                      listener: (context, authState) {
                        if (authState.status == AuthStatus.error) {
                          MyLoaders.errorSnackBar(
                            context: context,
                            title: "Oh no! ",
                            message:
                                authState.message ??
                                S.of(context).something_went_wrong,
                          );
                        } else if (authState.status == AuthStatus.success) {
                          MyLoaders.successSnackBar(
                            context: context,
                            title: "Success! ",
                            message:
                                authState.message ??
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                CircleAvatar(
                                                  radius:
                                                      MySizes.iconLarge(
                                                        context,
                                                      ) *
                                                      1.3,
                                                  backgroundColor:
                                                      MyColors.primaryShade100,
                                                  backgroundImage: context
                                                      .read<SetUpProfileCubit>()
                                                      .buildAvatarImageProvider(),
                                                  child:
                                                      state.pickedImage == null
                                                      ? HugeIcon(
                                                          icon: HugeIcons
                                                              .strokeRoundedCamera01,
                                                          size:
                                                              MySizes.iconLarge(
                                                                context,
                                                              ) *
                                                              1.3,
                                                          color: MyColors
                                                              .primaryShade700,
                                                        )
                                                      : null,
                                                ),
                                                Positioned(
                                                  right: 2,
                                                  bottom: 2,
                                                  child: InkWell(
                                                    onTap: state.isPickingImage
                                                        ? null
                                                        : () {
                                                            context
                                                                .read<
                                                                  SetUpProfileCubit
                                                                >()
                                                                .pickImage()
                                                                .onError((
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  MyLoaders.errorSnackBar(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Error',
                                                                    message:
                                                                        'Failed to pick image. Please try again.',
                                                                  );
                                                                  return null;
                                                                });
                                                          },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          999,
                                                        ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: MyColors
                                                            .primaryShade700,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child:
                                                          state.isPickingImage
                                                          ? SizedBox(
                                                              width:
                                                                  MySizes.iconSmall(
                                                                    context,
                                                                  ),
                                                              height:
                                                                  MySizes.iconSmall(
                                                                    context,
                                                                  ),
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                      Color
                                                                    >(
                                                                      MyColors
                                                                          .white,
                                                                    ),
                                                              ),
                                                            )
                                                          : Icon(
                                                              Iconsax.add,
                                                              size:
                                                                  MySizes.iconSmall(
                                                                    context,
                                                                  ),
                                                              color: MyColors
                                                                  .white,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MySizes.spaceLg(context),
                                        ),
                                        TextFeildWithLable(
                                          label: S.of(context).name,
                                          hintText: S
                                              .of(context)
                                              .enter_your_name,
                                          controller: _nameController,
                                        ),
                                        SizedBox(
                                          height: MySizes.spaceSm(context),
                                        ),
                                        Text(
                                          S.of(context).education_level,
                                          style: context.bodyLarge,
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(
                                          height: MySizes.spaceXs(context),
                                        ),
                                        DropdownButtonFormField<String>(
                                          initialValue:
                                              state.selectedEducationLevel.name,
                                          hint: Text(
                                            S
                                                .of(context)
                                                .select_education_level,
                                            style: context.bodyMedium,
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: EducationLevel
                                                  .highSchool
                                                  .name,
                                              child: Text(
                                                S.of(context).high_school,
                                                style: context.bodyMedium,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: EducationLevel
                                                  .underGraduate
                                                  .name,
                                              child: Text(
                                                S.of(context).undergraduate,
                                                style: context.bodyMedium,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value:
                                                  EducationLevel.graduated.name,
                                              child: Text(
                                                S.of(context).graduated,
                                                style: context.bodyMedium,
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              final level = EducationLevel
                                                  .values
                                                  .firstWhere(
                                                    (e) => e.name == value,
                                                  );
                                              context
                                                  .read<SetUpProfileCubit>()
                                                  .updateEducationLevel(level);
                                            }
                                          },
                                        ),
                                        if (state.isUnderGraduateSelected) ...[
                                          SizedBox(
                                            height: MySizes.spaceSm(context),
                                          ),
                                          TextFeildWithLable(
                                            label: S
                                                .of(context)
                                                .university_name,
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
                                      if (_nameController.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please enter your name',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      if (state.isUnderGraduateSelected &&
                                          (_universityController.text.isEmpty ||
                                              _universityController
                                                      .text
                                                      .length <
                                                  2)) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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
                                        levelOfEducation: state
                                            .selectedEducationLevel
                                            .serverValue,
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
      },
    );
  }
}
