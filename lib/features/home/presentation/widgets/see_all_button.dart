import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 8),
        ),
        splashColor: MyColors.white.withValues(alpha: 0.2),
        highlightColor: MyColors.white.withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryShade700,
                MyColors.primaryShade700.withValues(alpha: 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.responsiveValue(context, 8),
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryShade700.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MySizes.spaceXs(context) + 2,
            vertical: MySizes.spaceXs(context),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: ResponsiveHelper.responsiveValue(context, 6),
            children: [
              Text(
                'See all',
                style: context.bodySmall.copyWith(
                  fontSize: ResponsiveHelper.responsiveValue(context, 12.5),
                  fontWeight: FontWeight.w700,
                  color: MyColors.white,
                  letterSpacing: 0.3,
                ),
              ),
              HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                strokeWidth: ResponsiveHelper.responsiveValue(context, 2.5),
                size: ResponsiveHelper.responsiveValue(context, 14),
                color: MyColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
