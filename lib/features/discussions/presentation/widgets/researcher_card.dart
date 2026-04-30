import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/generated/l10n.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/profile_avatar.dart';

class ResearcherCard extends StatelessWidget {
  const ResearcherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 18),
        ),
        border: Border.all(
          color: MyColors.primaryShade300.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryShade500.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: -3,
          ),
          BoxShadow(
            color: MyColors.primaryShade900.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: MyColors.white.withValues(alpha: 0.6),
            blurRadius: 1,
            offset: const Offset(0, -1),
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
                  Text(
                    S.of(context).placeholder_researcher_name,
                    style: context.titleMedium,
                  ),
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.primaryShade500, MyColors.primaryShade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: MyColors.primaryShade500.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserAdd01,
                  size: ResponsiveHelper.responsiveValue(context, 20),
                  strokeWidth: ResponsiveHelper.responsiveValue(context, 2),
                  color: MyColors.white,
                ),
                padding: EdgeInsets.all(
                  ResponsiveHelper.responsiveValue(context, 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
