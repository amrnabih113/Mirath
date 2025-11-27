import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';

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
          title: "Terms and Conditions",
          message: "You must agree to the Terms and Conditions to sign up.",
        );
        return;
      }
      context.read<AuthCubit>().signUp(
        _usernameController.text.trim(),
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
            controller: _usernameController,

            decoration: const InputDecoration(hintText: "Username"),
            keyboardType: TextInputType.text,
            validator: (value) =>
                MyValidator.validateEmptyText("username", value),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: "Email"),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => MyValidator.validateEmail(value),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) => MyValidator.validatePassword(value),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureConfirmPassword,
            validator: (value) => MyValidator.validateConfirmPassword(
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
                      text: "I agree to the ",
                      style: context.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Terms and Conditions",
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
                              MyColors.textPrimary,
                            ),
                          ),
                        )
                      : const Text("Sign up"),
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
                text: "Already have an account? ",
                style: context.bodyMedium,
                children: [
                  TextSpan(
                    text: "Log in",
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
