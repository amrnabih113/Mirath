import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';

class VerifiedButtonWidget extends StatelessWidget {
 const VerifiedButtonWidget({
    super.key,
    required this.btnName,
    required this.otpCode,
  });
  final String btnName;
  final String otpCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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
                    if (btnName == "Verify email") {
                      context.read<AuthCubit>().verifyAccount(otpCode);
                    } else if (btnName == "Verify code") {
                      context.read<AuthCubit>().verifyResetPasswordOTP(otpCode);
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
                : Text(btnName),
          ),
        );
      },
    );
  }
}
