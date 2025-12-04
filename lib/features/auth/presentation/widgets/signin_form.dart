import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_validators.dart';
import '../cubit/auth_cubit.dart';

import '../../../../core/utils/my_sizes.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
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
            cursorColor: MyColors.primaryColor,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => MyValidator.validateEmail(value),
            style: context.bodyMedium.copyWith(color: MyColors.textPrimary),
            decoration: const InputDecoration(hintText: "Email or Username"),
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            cursorColor: MyColors.primaryColor,
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) => MyValidator.validatePassword(value),
            style: context.bodyMedium.copyWith(color: MyColors.textPrimary),
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                  color: MyColors.primaryShade900,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/forget-password');
                },
                child: Text(
                  "Forgot Password?",
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceLg(context)),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return SizedBox(
                width: MySizes.buttonWidth(context) * 1.3,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSignIn,
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
                      : const Text("Sign In"),
                ),
              );
            },
          ),
          SizedBox(height: MySizes.spaceLg(context)),
          GestureDetector(
            onTap: () {
              context.push('/signup');
            },
            child: Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: context.bodyMedium,
                children: [
                  TextSpan(
                    text: "Sign Up",
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
