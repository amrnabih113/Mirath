import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';
import 'package:mirath/generated/l10n.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool isButtonEnabled = false;

  void _handleResetPassword() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });
    if (_formKey.currentState!.validate()) {
      isButtonEnabled = true;
      context.read<AuthCubit>().resetPassword(_passController.text.trim());
    }
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      isButtonEnabled = isValid;
    });
  }

  @override
  void dispose() {
    _confirmPassController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(leading: MyBackIcon()),
      body: ScreenDecoration(
        dark: false,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              context.push('/signin');
            } else if (state.status == AuthStatus.error) {
              MyLoaders.warningSnackBar(
                context: context,
                title: "",
                message: state.message ?? "Something went wrong.",
              );
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topGap = screenHeight * 0.05; // ~12% of screen height
              return SafeArea(
                child: Padding(
                  padding: MySizes.paddingLg(context),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 850),
                      child: Column(
                        children: [
                          SizedBox(height: topGap),
                          Text(
                            S.of(context).Set_a_new_password,
                            style: context.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: MyColors.primaryShade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MySizes.spaceSm(context),
                          ), // Space between title and description
                          Text(
                            S.of(context).Create_a_new_password_description,
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: MySizes.spaceMd(context)),
                          Form(
                            key: _formKey,
                            autovalidateMode: _autovalidateMode,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _passController,
                                  validator: (value) =>
                                      MyValidator.validatePassword(value),
                                  cursorColor: MyColors.primaryColor,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).Your_new_password,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) => _validateForm(),
                                ),
                                SizedBox(height: MySizes.spaceMd(context)),
                                TextFormField(
                                  controller: _confirmPassController,
                                  validator: (value) =>
                                      MyValidator.validateConfirmPassword(
                                        _passController.text.trim(),
                                        value,
                                      ),
                                  cursorColor: MyColors.primaryColor,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).Confirm_password,
                                  ),
                                  onChanged: (_) => _validateForm(),
                                ),
                                SizedBox(height: MySizes.spaceLg(context)),

                                SizedBox(
                                  width: MySizes.buttonWidth(context),
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      final isLoading =
                                          state.status == AuthStatus.loading;

                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          disabledForegroundColor: Colors.white
                                              .withAlpha(128),
                                          foregroundColor: MyColors.black,
                                        ),
                                        onPressed:
                                            (!isButtonEnabled || isLoading)
                                            ? null
                                            : _handleResetPassword,

                                        child: isLoading
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: MyColors.light,
                                                    ),
                                              )
                                            : Text(
                                                S.of(context).Update_password,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                              ],
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
    );
  }
}
