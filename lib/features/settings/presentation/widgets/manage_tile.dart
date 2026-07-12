import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';

class ManageTile extends StatelessWidget {
  const ManageTile({
    super.key,
    this.buttonIcon,
    this.title,
    this.subtitle,
    this.btnName,
    this.onTap,
    this.textColor,
  });
  final List<List<dynamic>>? buttonIcon;
  final String? title;
  final String? subtitle;
  final String? btnName;
  final VoidCallback? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: context.bodyLarge.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle!,
          style: context.bodyMedium.copyWith(color: MyColors.darkerGrey),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              side: const BorderSide(color: MyColors.primaryShade800),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              btnName!,
              style: const TextStyle(color: MyColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
