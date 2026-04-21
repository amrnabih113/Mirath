import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class FollowerFollowingCard extends StatelessWidget {
  const FollowerFollowingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(context, 8)),
      width: double.infinity,
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
          ),
          BoxShadow(
            color: MyColors.primaryShade900.withValues(alpha: 0.03),
            blurRadius: ResponsiveHelper.responsiveValue(context, 8),
            offset: Offset(0, ResponsiveHelper.responsiveValue(context, 2)),
            spreadRadius: ResponsiveHelper.responsiveValue(context, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: MySizes.borderRadiusLg(context),
            child: SvgPicture.asset('assets/images/Profile picture (1).svg'),
          ),

          SizedBox(width: MySizes.spaceSm(context)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Jane Doe',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmall.copyWith(
                    color: MyColors.primaryShade900,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmall.copyWith(
                    color: MyColors.primaryShade900,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Egypt',
                  style: context.bodySmall.copyWith(
                    color: MyColors.primaryShade900,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: MySizes.spaceSm(context)),

          HugeIcon(icon: HugeIcons.strokeRoundedUserCheck01),
        ],
      ),
    );
  }
}
