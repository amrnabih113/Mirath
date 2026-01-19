import 'package:flutter/material.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).login_here,
          style: context.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        SizedBox(height: MySizes.spaceMd(context)),
        Text(
          S.of(context).welcome_back,
          style: context.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
