import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create Account",
          style: context.displayMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: MyColors.textPrimary,
          ),
        ),
        SizedBox(height: MySizes.spaceMd(context)),
        Text(
          "Welcome to Mirath! Create an account\nfor better research experience.",
          style: context.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
