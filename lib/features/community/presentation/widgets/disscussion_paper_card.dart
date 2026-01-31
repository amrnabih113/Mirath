import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/discussion_paper.dart';

class DisscussionPaperCard extends StatelessWidget {
  final String? paperId;
  final DiscussionPaper? paper;

  const DisscussionPaperCard({super.key, this.paperId, this.paper});

  @override
  Widget build(BuildContext context) {
    // If we don't have paper data, show a placeholder
    if (paper == null) {
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

    // Display actual paper data
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
                  paper!.title,
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MySizes.spaceXs(context) * 0.5),
                Text(
                  paper!.authors.join(', '),
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
