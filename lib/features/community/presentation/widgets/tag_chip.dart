import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class TagChip extends StatelessWidget {
  final String label;
  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MySizes.spaceSm(context),
        vertical: MySizes.spaceXs(context) * 0.5,
      ),
      decoration: BoxDecoration(
        color: MyColors.primaryShade100,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
      ),
      child: Text(
        label,
        style: context.bodySmall.copyWith(
          color: MyColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
