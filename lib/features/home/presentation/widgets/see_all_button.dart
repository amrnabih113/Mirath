import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.primaryShade700,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(
              context,
              5,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MySizes.spaceXs(context),
          vertical: MySizes.spaceXs(context) - 2,
        ),
        child: Row(
          spacing: ResponsiveHelper.responsiveValue(
            context,
            4,
          ),
          children: [
            Text(
              'See all',
    
              style: context.bodySmall.copyWith(
                fontSize:
                    ResponsiveHelper.responsiveValue(
                      context,
                      12,
                    ),
                fontWeight: FontWeight.w800,
                color: MyColors.white,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: MySizes.spaceSm(context) - 2,
              color: MyColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
