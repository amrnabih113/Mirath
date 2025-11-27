import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/generated/l10n.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(S.of(context).skip, style: context.bodyMedium),
    );
  }
}
