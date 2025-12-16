import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_sizes.dart';

class MyElevationButtonTheme {
  MyElevationButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme(
    BuildContext context,
  ) {
    final double fontSize = MySizes.bodyMedium(context); // responsive
    final double verticalPadding = MySizes.spaceMd(
      context,
    ); // responsive padding
    final double horizontalPadding = MySizes.spaceLg(
      context,
    ); // responsive padding

    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shadowColor: MyColors.primaryColor.withAlpha(128),
        foregroundColor: Colors.white,
        backgroundColor: MyColors.primaryColor,
        disabledBackgroundColor: MyColors.primaryShade300,
        disabledForegroundColor: MyColors.primaryShade50,
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  static ElevatedButtonThemeData darkElevatedButtonTheme(BuildContext context) {
    final double fontSize = MySizes.bodyMedium(context); // responsive
    final double verticalPadding = MySizes.spaceMd(
      context,
    ); // responsive padding

    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shadowColor: MyColors.primaryColor.withAlpha(128),
        foregroundColor: Colors.white,
        backgroundColor: MyColors.primaryColor,
        disabledBackgroundColor: MyColors.primaryShade300,
        disabledForegroundColor: MyColors.primaryShade50,
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
