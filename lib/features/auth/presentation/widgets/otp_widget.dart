import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    required this.title,
    required this.description,
    required this.btnName,
  });
  final String title;
  final String description;
  final String btnName;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  String otpCode = '';
  int secondsLeft = 60;
  Timer? countdownTimer;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer?.cancel();
    setState(() {
      canResend = false;
      secondsLeft = 60;
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: MyColors.primaryShade900,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.0), // Space between title and description
        Text(
          widget.description,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MySizes.spaceMd(context),
        ), // Space before the OTP fields
        PinCodeTextField(
          backgroundColor: Colors.transparent,
          length: 6,
          enableActiveFill: true,
          appContext: context,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          cursorColor: MyColors.primaryColor,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: MySizes.iconLarge(context) + 8,
            fieldWidth: MySizes.iconLarge(context) + 13,
            fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 0.5),
            activeFillColor: Colors.transparent,
            activeColor: MyColors.primaryShade500,
            inactiveColor: Colors.grey.shade600,
            selectedColor: MyColors.primaryShade500,
            inactiveFillColor: Colors.transparent,
            selectedFillColor: Colors.transparent,
          ),
          onCompleted: (value) {
            setState(() {
              otpCode = value;
            });
          },
        ),
        SizedBox(height: MySizes.spaceLg(context)),
        // Space before the button
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                minimumSize: Size(210, 40),
                backgroundColor: otpCode.length == 6
                    ? MyColors.primaryShade500
                    : MyColors.primaryShade300,
              ),
              onPressed: state.status == AuthStatus.otpSent
                  ? null
                  : () {
                      if (otpCode.length == 6) {
                        if (widget.btnName == "Verify Account") {
                          context.read<AuthCubit>().verifyAccount(otpCode);
                        } else if (widget.btnName == "Reset Password") {
                          context.read<AuthCubit>().verifyResetPasswordOTP(
                            otpCode,
                          );
                        }
                      } else {
                        MyLoaders.errorSnackBar(
                          context: context,
                          title: "Invalid Code",
                          message:
                              "Please enter the 6-digit code sent to your email.",
                        );
                      }
                    },
              child: Text(
                widget.btnName,
                style: TextStyle(
                  color: (otpCode.length) == 6
                      ? MyColors.primaryShade900
                      : MyColors.primaryShade100,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),

        SizedBox(height: MySizes.spaceXl(context)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              canResend
                  ? "Haven’t got the email yet? "
                  : "Resend code in $secondsLeft s",
              style: context.bodyMedium,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: canResend
                      ? () {
                          context.read<AuthCubit>().sendVerificationOTP();
                          startTimer();
                        }
                      : null,
                  child: canResend
                      ? Text(
                          "Resend Code",
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      : SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
