import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/utils/my_validators.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../cubit/auth_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      // We'll validate with context in the form validator instead
      final email = _emailController.text.trim();
      final isValid = email.isNotEmpty && email.contains('@');

      if (isValid != isButtonEnabled) {
        setState(() => isButtonEnabled = isValid);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgetPassword(
        email: _emailController.text.trim(),
      );
    }
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
              MyLoaders.successSnackBar(
                context: context,
                title: S.of(context).success,
                message:
                    state.message ?? S.of(context).password_reset_code_sent,
              );
              context.push('/verify-reset-otp');
            } else if (state.status == AuthStatus.error) {
              MyLoaders.errorSnackBar(
                context: context,
                title: S.of(context).error_title,
                message: state.message ?? S.of(context).something_went_wrong,
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
                            S.of(context).forget_password,
                            style: context.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),

                          SizedBox(height: MySizes.spaceMd(context)),

                          Text(
                            S.of(context).enter_email_reset,
                            style: context.titleMedium,
                          ),

                          SizedBox(height: MySizes.spaceXl(context)),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _emailController,
                              validator: (email) =>
                                  MyValidator.validateEmail(context, email),
                              cursorColor: MyColors.primaryColor,
                              decoration: InputDecoration(
                                hintText: S.of(context).email_address,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),

                          SizedBox(height: MySizes.spaceLg(context)),

                          SizedBox(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading =
                                    state.status == AuthStatus.loading;

                                return ElevatedButton(
                                  onPressed: isButtonEnabled
                                      ? _handleForgetPassword
                                      : null,

                                  child: isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: MyColors.light,
                                          ),
                                        )
                                      : Text(S.of(context).reset_password),
                                );
                              },
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
