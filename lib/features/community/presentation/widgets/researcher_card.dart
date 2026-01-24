import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/profile_avatar.dart';

class ResearcherCard extends StatelessWidget {
  const ResearcherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        border: Border.all(color: MyColors.primaryShade500),
        boxShadow: [
          BoxShadow(
            color: MyColors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: MySizes.paddingSm(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(),
            SizedBox(width: MySizes.spaceMd(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jane Doe', style: context.titleMedium),
                  SizedBox(height: MySizes.spaceXs(context)),
                  Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context)),
                  Text(
                    'Egypt',
                    style: context.bodySmall.copyWith(
                      color: MyColors.primaryShade700,
                    ),
                  ),
                ],
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedUserAdd01,
              size: ResponsiveHelper.responsiveValue(context, 25),
              strokeWidth: ResponsiveHelper.responsiveValue(context, 2),
              color: MyColors.primaryShade700,
            ),
          ],
        ),
      ),
    );
  }
}
