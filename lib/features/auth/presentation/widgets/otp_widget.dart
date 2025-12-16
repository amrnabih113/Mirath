import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/auth_cubit.dart';
import '../../../../generated/l10n.dart';
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
          style: context.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: MyColors.primaryShade900,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MySizes.spaceSm(context),
        ), // Space between title and description
        Text(
          widget.description,
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w400),
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
          textStyle: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: MyColors.primaryShade900,
          ),

          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          cursorColor: MyColors.primaryColor,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: MySizes.iconLarge(context) * 1.2,
            fieldWidth: MySizes.iconLarge(context) * 1.2,
            fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 0.5),
            activeFillColor: Colors.transparent,
            activeColor: MyColors.primaryShade500,
            inactiveColor: Colors.grey.shade600,
            selectedColor: MyColors.primaryShade500,
            inactiveFillColor: Colors.transparent,
            selectedFillColor: Colors.transparent,
            borderWidth: MySizes.spaceXs(context) * 1.2,
          ),
          onChanged: (value) => {
            setState(() {
              if (value.length < 6) {
                otpCode = value;
              }
            }),
          },
          onCompleted: (value) {
            setState(() {
              otpCode = value;
            });
          },
        ),
        SizedBox(height: MySizes.spaceLg(context)),

        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SizedBox(
              width: MySizes.buttonWidth(context),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.white.withAlpha(128),
                  foregroundColor: MyColors.black,
                ),
                onPressed: otpCode.length == 6
                    ? () {
                        if (widget.btnName == "Verify email") {
                          context.read<AuthCubit>().verifyAccount(otpCode);
                        } else if (widget.btnName == "Verify code") {
                          context.read<AuthCubit>().verifyResetPasswordOTP(
                            otpCode,
                          );
                        }
                      }
                    : null,
                child: state.status == AuthStatus.loading
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
                    : Text(widget.btnName),
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
                  ? S.of(context).Have_not_got_yet
                  : "${S.of(context).Resend_code_in}$secondsLeft s",
              style: context.bodyMedium,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: canResend
                      ? () {
                          context.read<AuthCubit>().sendVerificationOTP();
                          startTimer();
                          setState(() {
                            otpCode = '';
                          });
                        }
                      : null,
                  child: canResend
                      ? Text(
                          S.of(context).Resend_code,
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
