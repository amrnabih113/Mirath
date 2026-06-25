import 'package:flutter/material.dart';

import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/color_picker.dart';
import 'package:mirath/features/settings/presentation/widgets/reading_tile.dart';

class ReadingAppearance extends StatefulWidget {
  const ReadingAppearance({super.key});

  @override
  State<ReadingAppearance> createState() => _ReadingAppearanceState();
}

class _ReadingAppearanceState extends State<ReadingAppearance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Reading & Appearance',
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Display & Appearance',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              ReadingTile(
                title: 'Color mode',
                items: ['Light mode', 'Dark mode'],
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              ReadingTile(
                title: 'Default paper font size',
                items: ['Small', 'Medium', 'Large'],
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Reading & Annotations',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              ReadingTile(
                title: 'Default reading list visibility',
                items: ['Public', 'Privet'],
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Annotation highlight colors',
                style: context.bodyLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Default colors applied when you highlight text',
                style: context.bodyLarge.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MyColors.darkerGrey,
                ),
              ),
              SizedBox(height: 16),
              ColorPalette(),
            ],
          ),
        ),
      ),
    );
  }
}
