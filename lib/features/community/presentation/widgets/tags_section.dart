import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'add_discussion_tag_chip.dart';

class TagsSection extends StatelessWidget {
  final List<String> tags;
  final Function(String tag) onRemoveTag;

  const TagsSection({super.key, required this.tags, required this.onRemoveTag});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (${tags.length}/5)',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveValue(context, 18),
            fontWeight: FontWeight.w600,
            color: MyColors.primaryShade900,
          ),
        ),
        SizedBox(height: MySizes.spaceSm(context)),
        if (tags.isEmpty)
          Text(
            'Add tags to categorize your discussion',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveValue(context, 14),
              color: MyColors.primaryShade500,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: MySizes.spaceSm(context),
            runSpacing: MySizes.spaceSm(context),
            children: tags
                .map(
                  (tag) => AddDiscussionTagChip(
                    label: tag,
                    onRemove: () => onRemoveTag(tag),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
