import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/auth/presentation/widgets/login_header.dart';
import 'package:mirath/features/auth/presentation/widgets/signin_form.dart';
import 'package:mirath/features/auth/presentation/widgets/signin_social_buttons.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

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
                SizedBox(height: 180),
                const LoginHeader(),
                SizedBox(height: MySizes.spaceXl(context) * 2),
                const SigninForm(),
                SizedBox(height: MySizes.spaceLg(context)),
                SocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
