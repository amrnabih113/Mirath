import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.primaryShade700,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 5),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MySizes.spaceXs(context),
          vertical: MySizes.spaceXs(context) - 2,
        ),
        child: Row(
          spacing: ResponsiveHelper.responsiveValue(context, 4),
          children: [
            Text(
              'See all',

              style: context.bodySmall.copyWith(
                fontSize: ResponsiveHelper.responsiveValue(context, 12),
                fontWeight: FontWeight.w800,
                color: MyColors.white,
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              strokeWidth: ResponsiveHelper.responsiveValue(context, 4),
              size: MySizes.spaceMd(context),
              color: MyColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
