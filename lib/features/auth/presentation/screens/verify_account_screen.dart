import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/auth/presentation/widgets/otp_widget.dart';
import 'package:mirath/features/auth/presentation/widgets/timer_widget.dart';
import 'package:mirath/features/auth/presentation/widgets/verified_button_widget.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';
import 'package:mirath/generated/l10n.dart';

class VerifyAccountScreen extends StatelessWidget {
  VerifyAccountScreen({super.key});

  final ValueNotifier<String> _otpCodeNotifier = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.otpSent) {
          MyLoaders.successSnackBar(
            context: context,
            title: S.of(context).success,
            message: state.message ?? S.of(context).otp_sent_success,
          );
        } else if (state.status == AuthStatus.authenticated) {
          MyLoaders.successSnackBar(
            context: context,
            title: S.of(context).verified,
            message: state.message ?? S.of(context).account_verified_success,
          );
          context.pushReplacement('/home');
        } else if (state.status == AuthStatus.error) {
          MyLoaders.errorSnackBar(
            context: context,
            title: S.of(context).error_title,
            message: state.message ?? S.of(context).something_went_wrong,
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
              final topGap = screenHeight * 0.05;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topGap,
                    left: MySizes.spaceLg(context),
                    right: MySizes.spaceLg(context),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 850),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.15),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  OtpWidget(
                                    title: S.of(context).Verify_your_email,
                                    description: S
                                        .of(context)
                                        .OTP_code_description,
                                    onOtpCompleted: (value) {
                                      _otpCodeNotifier.value = value;
                                    },
                                  ),
                                  // نربط الزر بالـ ValueListenableBuilder عشان نقرى otpCode
                                  ValueListenableBuilder<String>(
                                    valueListenable: _otpCodeNotifier,
                                    builder: (context, otpCode, _) {
                                      return VerifiedButtonWidget(
                                        actionType:
                                            VerifyActionType.verifyEmail,
                                        otpCode: otpCode,
                                      );
                                    },
                                  ),
                                  SizedBox(height: MySizes.spaceLg(context)),
                                  const TimerWidget(),
                                ],
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
