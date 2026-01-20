import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: MySizes.spaceXs(context),
      ),
      leading: HugeIcon(
        icon: HugeIcons.strokeRoundedSearch01,
        size: MySizes.iconSmall(context),
        color: MyColors.primaryShade300,
      ),
      title: Text(
        'Quantum Mechanics',
        style: context.bodySmall.copyWith(
          fontSize: ResponsiveHelper.responsiveValue(context, 16),
          fontWeight: FontWeight.w400,
          color: MyColors.black,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedCancel01,
          size: MySizes.iconSmall(context),
          color: MyColors.primaryShade900,
        ),
      ),
    );
  }
}
