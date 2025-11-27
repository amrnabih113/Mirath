import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';
import 'package:mirath/features/auth/presentation/widgets/signup_header.dart';
import 'package:mirath/features/auth/presentation/widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.pushReplacement('/home');
          } else if (state.status == AuthStatus.unverified) {
            context.pushReplacement('/verify-account');
          } else if (state.message != null && state.message!.isNotEmpty) {
            MyLoaders.errorSnackBar(
              context: context,
              title: "Oh no! ",
              message: state.message!,
            );
          }
        },
        child: ScreenDecoration(
          child: SingleChildScrollView(
            padding: MySizes.paddingLg(context),
            child: Column(
              children: [
                SizedBox(height: 100),
                const SignupHeader(),
                SizedBox(height: MySizes.spaceXl(context) * 2),
                const SignupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
