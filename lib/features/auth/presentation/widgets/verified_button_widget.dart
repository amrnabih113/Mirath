import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/auth_cubit.dart';
import '../../../../generated/l10n.dart';

enum VerifyActionType { verifyEmail, verifyCode }

class VerifiedButtonWidget extends StatelessWidget {
  const VerifiedButtonWidget({
    super.key,
    required this.actionType,
    required this.otpCode,
  });
  final VerifyActionType actionType;
  final String otpCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: MySizes.buttonWidth(context),
          child: ElevatedButton(
            onPressed: otpCode.length == 6
                ? () {
                    if (actionType == VerifyActionType.verifyEmail) {
                      context.read<AuthCubit>().verifyAccount(otpCode);
                    } else if (actionType == VerifyActionType.verifyCode) {
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
                : Text(
                    actionType == VerifyActionType.verifyEmail
                        ? S.of(context).Verify_email
                        : S.of(context).Verify_code,
                  ),
          ),
        );
      },
    );
  }
}
