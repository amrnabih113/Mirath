import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../home/domain/entities/paper_entity.dart';
import 'add_discussion_paper_card.dart';

class RelatedPapersSection extends StatelessWidget {
  final List<PaperEntity> papers;
  final Function(PaperEntity paper) onRemovePaper;

  const RelatedPapersSection({
    super.key,
    required this.papers,
    required this.onRemovePaper,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Papers',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveValue(context, 18),
            fontWeight: FontWeight.w600,
            color: MyColors.primaryShade900,
          ),
        ),
        SizedBox(height: MySizes.spaceSm(context)),
        if (papers.isEmpty)
          Text(
            'Add papers to support your discussion',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveValue(context, 14),
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Column(
            children: papers
                .map(
                  (paper) => AddDiscussionPaperCard(
                    paper: paper,
                    onRemove: () => onRemovePaper(paper),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
