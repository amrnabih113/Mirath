import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int secondsLeft = 60;
  Timer? countdownTimer;
  bool canResend = false;
  final String otpCode = '';

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
  Widget build(Object context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          canResend
              ? "Haven’t got the email yet? "
              : "Resend code in $secondsLeft s",
          //      style: context.bodyMedium,
        ),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: canResend
                  ? () {
                      context.read<AuthCubit>().sendVerificationOTP();
                      startTimer();
                      setState(() {
                        otpCode;
                      });
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
    );
  }
}
