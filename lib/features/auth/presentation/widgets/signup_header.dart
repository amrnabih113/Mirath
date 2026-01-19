import 'package:flutter/material.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).create_account,
          style: context.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        SizedBox(height: MySizes.spaceMd(context)),
        Text(
          S.of(context).welcome_to_mirath,
          style: context.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
