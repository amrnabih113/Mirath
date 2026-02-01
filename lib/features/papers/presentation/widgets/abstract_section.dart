import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/papers/presentation/widgets/latex_renderer.dart';
import 'package:mirath/features/papers/presentation/widgets/my_text_icon.dart';

class AbstractSection extends StatelessWidget {
  final String abstractText;
  final int? discussionsCount;
  final VoidCallback? onViewDiscussions;
  final VoidCallback? onStartDiscussion;

  const AbstractSection({
    super.key,
    required this.abstractText,
    this.discussionsCount,
    this.onViewDiscussions,
    this.onStartDiscussion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Abstract',
          style: context.headlineSmall.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: MySizes.spaceXs(context)),
        abstractText.isEmpty
            ? Text('No abstract available.', style: context.bodyMedium)
            : LaTeXRenderer(text: abstractText, textStyle: context.bodyMedium),
        SizedBox(height: MySizes.spaceMd(context)),
        Text(
          'Discussions',
          style: context.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: MyTextButton(
                title: discussionsCount != null
                    ? 'View Discussions ($discussionsCount)'
                    : 'View Discussions',
                titleColor: MyColors.primaryShade900,
                buttonColor: MyColors.white,
                // onPressed: onViewDiscussions,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MySizes.borderRadiusLg(context),
                  ),
                  side: BorderSide(color: MyColors.primaryShade700),
                ),
              ),
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            Expanded(
              flex: 9,

              child: MyTextButton(
                title: 'Start a Discussion',
                icon: Icons.add,
                hasIcon: true,
                titleColor: MyColors.white,
                buttonColor: MyColors.primaryShade800,
                // onPressed: onStartDiscussion,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MySizes.borderRadiusLg(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
