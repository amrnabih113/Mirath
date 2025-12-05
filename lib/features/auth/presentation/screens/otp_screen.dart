import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/auth/presentation/widgets/otp_widget.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          MyLoaders.successSnackBar(
            context: context,
            title: "Verified!",
            message: state.message ?? "otp verified successfully.",
          );
          // Navigate to reset password screen
          context.pushReplacement('/reset-password');
        } else if (state.status == AuthStatus.error) {
          MyLoaders.warningSnackBar(
            context: context,
            title: "",
            message: state.message ?? "Something went wrong.",
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: MyBackIcon()),
        body: ScreenDecoration(
          dark: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topGap = screenHeight * 0.05; // ~12% of screen height
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topGap,
                    left: MySizes.spaceLg(context),
                    right: MySizes.spaceLg(context),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 850),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.15),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return OtpWidget(
                                title: 'Password Reset',
                                description:
                                    'We just sent a 6-digit code to your email, enter it below:',
                                btnName: 'Verify code',
                              );
                            },
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
