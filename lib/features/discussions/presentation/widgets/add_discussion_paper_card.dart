import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';

class AddDiscussionPaperCard extends StatelessWidget {
  final PaperEntity paper;
  final VoidCallback onRemove;

  const AddDiscussionPaperCard({
    super.key,
    required this.paper,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MySizes.spaceSm(context)),
      padding: EdgeInsets.all(MySizes.spaceSm(context)),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.primaryShade300, width: 1.5),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 12),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document icon
          Container(
            padding: EdgeInsets.all(MySizes.spaceXs(context)),
            decoration: BoxDecoration(
              color: MyColors.primaryShade100,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.responsiveValue(context, 8),
              ),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedFile02,
              color: MyColors.primaryColor,
              size: ResponsiveHelper.responsiveValue(context, 20),
            ),
          ),
          SizedBox(width: MySizes.spaceSm(context)),

          // Paper info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paper.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveValue(context, 14),
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryShade900,
                  ),
                ),
                SizedBox(height: MySizes.spaceXs(context) / 2),
                Text(
                  paper.authors.take(2).join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveValue(context, 12),
                    color: MyColors.primaryShade600,
                  ),
                ),
              ],
            ),
          ),

          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCancel01,
              size: ResponsiveHelper.responsiveValue(context, 20),
            ),
          ),
        ],
      ),
    );
  }
}
