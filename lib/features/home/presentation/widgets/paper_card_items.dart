import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class PaperCardItems extends StatelessWidget {
  const PaperCardItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.responsiveValue(context, 8),
          vertical: ResponsiveHelper.responsiveValue(context, 4),
        ),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
          border: Border.all(color: MyColors.primaryShade800, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'J. Phys. Commun. • 2022',
                  style: context.bodySmall.copyWith(
                    color: MyColors.primaryShade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    HugeIconsSolid.bookmark02,
                    color: MyColors.primaryShade700,
                    size: ResponsiveHelper.responsiveValue(context, 20),
                  ),
                ),
              ],
            ),
            Text(
              'What does it take to solve the measurement problem?',
              style: context.titleMedium.copyWith(
                color: MyColors.primaryShade900,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MySizes.spaceXs(context)),
            Text(
              'Jonte R Hance and Sabine Hossenfelder',
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade800,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveHelper.responsiveValue(context, 12),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            Wrap(
              spacing: MySizes.spaceXs(context) / 2,
              runSpacing: MySizes.spaceXs(context),
              children: [
                _tag(context, 'Quantum Mechanics'),
                _tag(context, 'The Measurement Problem'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(context, 8),
        vertical: ResponsiveHelper.responsiveValue(context, 4),
      ),
      decoration: BoxDecoration(
        color: MyColors.primaryShade200.withAlpha(150),
        borderRadius: BorderRadius.circular(
          MySizes.borderRadiusSm(context) - 4,
        ),
      ),
      child: Text(
        text,
        style: context.bodySmall.copyWith(
          fontSize: ResponsiveHelper.responsiveValue(context, 11),
          color: MyColors.primaryShade900,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
