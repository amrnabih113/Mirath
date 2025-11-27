import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/my_helper_functions.dart';
import 'package:mirath/core/utils/my_colors.dart';

class MyBackIcon extends StatelessWidget {
  const MyBackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => context.pop(),
      child: Icon(
        Icons.arrow_back_ios,
        color: !isDark ? MyColors.textPrimary : MyColors.textPrimaryDark,
      ),
    );
  }
}
