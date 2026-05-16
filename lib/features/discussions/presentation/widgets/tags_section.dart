import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import 'add_discussion_tag_chip.dart';

class TagsSection extends StatelessWidget {
  final List<String> tagNames; // Tag names only
  final Function(String tag) onRemoveTag;

  const TagsSection({
    super.key,
    required this.tagNames,
    required this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (${tagNames.length}/5)',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveValue(context, 18),
            fontWeight: FontWeight.w600,
            color: MyColors.primaryShade900,
          ),
        ),
        SizedBox(height: MySizes.spaceSm(context)),
        if (tagNames.isEmpty)
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
            children: tagNames
                .map(
                  (tagName) => AddDiscussionTagChip(
                    label: tagName,
                    onRemove: () => onRemoveTag(tagName),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
