import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/tag_chip.dart';
import '../../domain/entities/discussion.dart';
import 'disscusion_action_buttons.dart';
import 'disscussion_paper_card.dart';
import 'user_information_header.dart';

class DiscussionCard extends StatefulWidget {
  final Discussion discussion;
  final void Function()? onTap;

  const DiscussionCard({super.key, required this.discussion, this.onTap});

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingSm(context),
      decoration: BoxDecoration(
        color: MyColors.white,

        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 18),
        ),
        border: Border.all(
          color: MyColors.primaryShade200.withValues(alpha: 0.4),
          width: ResponsiveHelper.responsiveValue(context, 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryShade500.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: Offset(0, 5),
            spreadRadius: -3,
          ),
          BoxShadow(
            color: MyColors.primaryShade900.withValues(alpha: 0.03),
            blurRadius: ResponsiveHelper.responsiveValue(context, 10),
            offset: Offset(0, ResponsiveHelper.responsiveValue(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Column(
              children: [
                UserInformationHeader(discussion: widget.discussion),
                SizedBox(height: MySizes.spaceMd(context)),
                Text(
                  widget.discussion.title,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.3,
                    color: MyColors.primaryShade900,
                  ),
                ),
                SizedBox(height: MySizes.spaceSm(context) * 1.2),
                Text(
                  widget.discussion.content,
                  style: context.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MySizes.spaceMd(context)),
                if (widget.discussion.paperIds.isNotEmpty)
                  DisscussionPaperCard(
                    paperId: widget.discussion.paperIds.first,
                  ),
                if (widget.discussion.paperIds.isNotEmpty)
                  SizedBox(height: MySizes.spaceMd(context)),
                SizedBox(
                  height: ResponsiveHelper.responsiveValue(context, 28),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final topic = widget.discussion.topics[index];
                      return TagChip(label: topic.name);
                    },
                    separatorBuilder: (_, __) =>
                        SizedBox(width: MySizes.spaceXs(context)),
                    itemCount: widget.discussion.topics.length,
                  ),
                ),
                SizedBox(height: MySizes.spaceMd(context)),
              ],
            ),
          ),
          DisscusionActionButtons(discussion: widget.discussion),
        ],
      ),
    );
  }
}
