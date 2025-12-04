import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/auth_cubit.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../widgets/signup_header.dart';
import '../widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(leading: MyBackIcon()),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topGap = screenHeight * 0.15; // ~20% of screen height
              final formGap = screenHeight * 0.03; // ~3% of screen height

              return SingleChildScrollView(
                padding: MySizes.paddingLg(context),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 850),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: topGap),
                        const SignupHeader(),
                        SizedBox(height: formGap),
                        const SignupForm(),
                      ],
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
