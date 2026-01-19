import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/utils/my_validators.dart';
import '../../../../generated/l10n.dart';
import '../cubit/auth_cubit.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        MyLoaders.warningSnackBar(
          context: context,
          title: S.of(context).warning_title,
          message: S.of(context).terms_agreement_required,
        );
        return;
      }
      context.read<AuthCubit>().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,

            decoration: InputDecoration(hintText: S.of(context).username),
            keyboardType: TextInputType.text,
            validator: (value) =>
                MyValidator.validateEmptyText(context, S.of(context).username, value),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(hintText: S.of(context).email),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => MyValidator.validateEmail(context,value),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: S.of(context).password,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                  color: MyColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) => MyValidator.validatePassword(context,value),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              hintText: S.of(context).confirm_password_hint,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                  color: MyColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureConfirmPassword,
            validator: (value) => MyValidator.validateConfirmPassword(context,
              value,
              _passwordController.text,
            ),

            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Row(
            children: [
              Checkbox(
                value: _agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _agreedToTerms = !_agreedToTerms;
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                      text: S.of(context).i_agree_to,
                      style: context.bodyMedium,
                      children: [
                        TextSpan(
                          text: S.of(context).terms_and_conditions,
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceLg(context)),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return SizedBox(
                width: MySizes.buttonWidth(context) * 1.3,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MyColors.textPrimary,
                    padding: EdgeInsets.symmetric(
                      vertical: MySizes.spaceMd(context),
                      horizontal: MySizes.spaceLg(context),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MyColors.primaryShade50,
                            ),
                          ),
                        )
                      : Text(S.of(context).sign_up),
                ),
              );
            },
          ),
          SizedBox(height: MySizes.spaceLg(context)),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Text.rich(
              TextSpan(
                text: S.of(context).already_have_account,
                style: context.bodyMedium,
                children: [
                  TextSpan(
                    text: S.of(context).log_in,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
