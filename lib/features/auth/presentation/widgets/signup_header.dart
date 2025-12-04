import 'package:flutter/material.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create Account",
          style: context.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 40,
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
