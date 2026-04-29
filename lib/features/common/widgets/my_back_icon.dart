import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/my_helper_functions.dart';
import '../../../core/utils/my_colors.dart';
import '../../../core/utils/my_sizes.dart';

class MyBackIcon extends StatelessWidget {
  const MyBackIcon({super.key, this.onTap, this.padding = true});
  final VoidCallback? onTap;
  final bool padding;
  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap ?? () => context.pop(),
      child: Padding(
        padding: padding
            ? EdgeInsets.symmetric(horizontal: MySizes.spaceLg(context))
            : EdgeInsets.zero,
        child: Icon(
          Icons.arrow_back_ios,
          size: MySizes.iconMedium(context),
          color: !isDark ? MyColors.textPrimary : MyColors.textPrimaryDark,
        ),
      ),
    );
  }
}
