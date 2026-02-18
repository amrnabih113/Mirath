import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/home/presentation/widgets/search_text_field.dart';

class EditInterstsScreen extends StatelessWidget {
  const EditInterstsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: Padding(
        padding: MySizes.paddingSm(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit your interests',
              style: context.headlineLarge.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SearchTextField(
              hasIcon: false,
              hint: 'Search a topic (e.g. Computer Science)',
            ),
            Wrap(
              runSpacing: MySizes.spaceSm(context),
              children: [
                TagChip(label: 'Physics', hasIcon: true),
                SizedBox(width: MySizes.spaceSm(context)),
                TagChip(label: 'Physics', hasIcon: true),
                SizedBox(width: MySizes.spaceSm(context)),
                TagChip(label: 'Physics', hasIcon: true),
                SizedBox(width: MySizes.spaceSm(context)),
                TagChip(label: 'Physics', hasIcon: true),
                SizedBox(width: MySizes.spaceSm(context)),
                TagChip(label: 'Physics', hasIcon: true),
                SizedBox(width: MySizes.spaceSm(context)),
                TagChip(label: 'Physics', hasIcon: true),
              ],
            ),
            SizedBox(height: MySizes.spaceXl(context)),
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: MyColors.primaryShade800,
                ),
                child: Text(
                  'save changes',
                  style: context.bodySmall.copyWith(
                    color: MyColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
