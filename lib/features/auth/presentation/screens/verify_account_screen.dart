import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/otp_widget.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../../../../generated/l10n.dart';

class VerifyAccountScreen extends StatelessWidget {
  const VerifyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.otpSent) {
          MyLoaders.successSnackBar(
            context: context,
            title: "Success!",
            message: state.message ?? "otp sent successfully.",
          );
        } else if (state.status == AuthStatus.otpVerified) {
          MyLoaders.successSnackBar(
            context: context,
            title: "Verified!",
            message: state.message ?? "otp verified successfully.",
          );
          // Navigate to reset password screen
          context.pushReplacement('/home');
        } else if (state.status == AuthStatus.error) {
          MyLoaders.errorSnackBar(
            context: context,
            title: "Oh no!",
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
                                title: S.of(context).Verify_your_email,
                                description: S.of(context).OTP_code_description,
                                btnName: S.of(context).Verify_email,
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
