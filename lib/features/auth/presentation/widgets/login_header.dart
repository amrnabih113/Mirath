import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Login Here",
          style: context.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        SizedBox(height: MySizes.spaceMd(context)),
        Text(
          "Welcome back to Mirath!",
          style: context.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
