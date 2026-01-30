import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class DisscussionPaperCard extends StatelessWidget {
  final String paperId;

  const DisscussionPaperCard({super.key, required this.paperId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingSm(context),
      decoration: BoxDecoration(
        color: MyColors.primaryShade50,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
        border: Border.all(color: MyColors.primaryShade400),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedFile02,
            size: MySizes.iconLarge(context),
            color: MyColors.textSecondary,
          ),
          SizedBox(width: MySizes.spaceSm(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What does it take to solve the...',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MySizes.spaceXs(context) * 0.5),
                Text(
                  'Jonte R Hance and Sabine Hossenfelder',
                  style: context.bodySmall.copyWith(
                    color: MyColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
