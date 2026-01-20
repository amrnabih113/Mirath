import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_sizes.dart';

class MyTextButtonTheme {
  MyTextButtonTheme._();

  static TextButtonThemeData lightTextButtonTheme(BuildContext context) {
    final double fontSize = MySizes.bodyMedium(context); // responsive
    final double verticalPadding =
        MySizes.spaceMd(context) - 5; // responsive padding
    final double horizontalPadding = MySizes.spaceLg(
      context,
    ); // responsive padding

    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MyColors.primaryShade700,
        disabledForegroundColor: MyColors.primaryShade700.withAlpha(120),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  static TextButtonThemeData darkTextButtonTheme(BuildContext context) {
    final double fontSize = MySizes.bodyMedium(context); // responsive
    final double verticalPadding =
        MySizes.spaceMd(context) - 5; // responsive padding
    final double horizontalPadding = MySizes.spaceLg(
      context,
    ); // responsive padding

    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MyColors.primaryColor,
        disabledForegroundColor: MyColors.primaryShade300.withAlpha(120),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
