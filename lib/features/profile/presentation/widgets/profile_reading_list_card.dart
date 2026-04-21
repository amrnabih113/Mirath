import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';

class ProfileReadingListCard extends StatelessWidget {
  const ProfileReadingListCard({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(context, 16)),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 16),
          ),
          border: Border.all(color: MyColors.primaryShade800, width: 1),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.06),
              blurRadius: ResponsiveHelper.responsiveValue(context, 16),
              offset: Offset(0, ResponsiveHelper.responsiveValue(context, 4)),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.03),
              blurRadius: ResponsiveHelper.responsiveValue(context, 8),
              offset: Offset(0, ResponsiveHelper.responsiveValue(context, 2)),
              spreadRadius: ResponsiveHelper.responsiveValue(context, -2),
            ),
          ],
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
                  'Introduction to CNN',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.titleMedium.copyWith(
                    color: MyColors.primaryShade900,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: -0.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                HugeIcon(icon: HugeIcons.strokeRoundedGlobal),
              ],
            ),
            Text(
              '8 papers • Updated 2 days ago',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade700,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.responsiveValue(context, 13),
              ),
            ),
            Divider(color: MyColors.primaryShade800, thickness: 2),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade700,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.responsiveValue(context, 13),
              ),
            ),
            Wrap(
              children: [
                TagChip(label: 'Artificial Intelligence'),
                SizedBox(width: MySizes.spaceXs(context) * .5),
                TagChip(label: 'CNN'),
                SizedBox(width: MySizes.spaceLg(context) * 5),
                HugeIcon(icon: HugeIcons.strokeRoundedMoreHorizontal),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
