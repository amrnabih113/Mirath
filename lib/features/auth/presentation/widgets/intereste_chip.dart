import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class InteresteChip extends StatelessWidget {
  const InteresteChip({super.key, required this.interest, this.onDeleted});
  final String interest;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      color: WidgetStatePropertyAll(MyColors.primaryColor),
      padding: EdgeInsets.symmetric(
        horizontal: MySizes.spaceMd(context) * 0.5,
        vertical: MySizes.spaceMd(context),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyColors.primaryShade800),
        borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
      ),
      label: Text(
        interest,
        style: context.bodySmall.copyWith(
          fontWeight: FontWeight.bold,
          color: MyColors.black,
        ),
      ),
      deleteIcon: HugeIcon(
        icon: HugeIcons.strokeRoundedMultiplicationSign,
        size: MySizes.iconSmall(context),
        color: MyColors.black,
        strokeWidth: 2,
      ),
      onDeleted: onDeleted,
    );
  }
}
