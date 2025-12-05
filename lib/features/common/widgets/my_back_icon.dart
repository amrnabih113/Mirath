import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/my_helper_functions.dart';
import '../../../core/utils/my_colors.dart';
import '../../../core/utils/my_sizes.dart';

class MyBackIcon extends StatelessWidget {
  const MyBackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => context.pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MySizes.spaceLg(context)),
        child: Icon(
          Icons.arrow_back_ios,
          size: MySizes.iconMedium(context),
          color: !isDark ? MyColors.textPrimary : MyColors.textPrimaryDark,
        ),
      ),
    );
  }
}
