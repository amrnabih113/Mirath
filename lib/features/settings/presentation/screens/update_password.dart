import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/setting_text_field.dart';
import 'package:mirath/generated/l10n.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSuccess<String>) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.data)));
            context.read<ProfileCubit>().loadCurrentUser();
            context.pop();
          } else if (state is SettingsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errormessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is SettingsLoading;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Padding(
                padding: MySizes.paddingLg(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Update Your Password',
                      style: context.bodyLarge.copyWith(fontSize: 24),
                    ),
                    SizedBox(height: MySizes.spaceXl(context)),
                    SettingsTextField(
                      obscureText: true,
                      controller: _currentPasswordController,
                      hintText: 'your current password',
                      validator: (value) =>
                          MyValidator.validatePassword(context, value),
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    SettingsTextField(
                      obscureText: true,
                      controller: _newPasswordController,
                      hintText: 'your new password',
                      validator: (value) =>
                          MyValidator.validatePassword(context, value),
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),

                    SettingsTextField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      hintText: 'Confirm password',
                      validator: (value) => MyValidator.validateConfirmPassword(
                        context,
                        _newPasswordController.text,
                        _confirmPasswordController.text,
                      ),
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          context.push(RouteNames.forgetPassword);
                        },
                        child: Text(
                          S.of(context).forgot_password,
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MySizes.spaceSm(context)),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final isValid = _formKey.currentState!.validate();

                              if (!isValid) {
                                setState(() {
                                  _autoValidateMode =
                                      AutovalidateMode.onUserInteraction;
                                });
                                return;
                              }

                              context.read<SettingsCubit>().updatePassword(
                                currentPassword: _currentPasswordController.text
                                    .trim(),
                                newPassword: _newPasswordController.text.trim(),
                                confirmNewpassword: _confirmPasswordController
                                    .text
                                    .trim(),
                              );
                            },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            _newPasswordController.text ==
                                    _confirmPasswordController.text &&
                                _currentPasswordController.text.isNotEmpty
                            ? MyColors.primaryShade800
                            : MyColors.primaryShade800.withAlpha(
                                (255 * 0.5).toInt(),
                              ),
                      ),
                      child: Text(
                        'Update Password',
                        style: context.bodyLarge.copyWith(
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
