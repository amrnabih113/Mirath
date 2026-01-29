import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_sizes.dart'; // your responsive helper

class MyTextFieldTheme {
  MyTextFieldTheme._();

  static OutlineInputBorder _border({
    Color? color,
    double width = 0,
    double radius = 15,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color ?? MyColors.primaryShade800,
        width: width,
      ),
    );
  }

  static InputDecorationThemeData lightInputDecorationThemeData(
    BuildContext context,
  ) {
    final padding = MySizes.spaceMd(context); // example responsive padding
    final iconSize = MySizes.spaceXl(context); // example icon size
    final fontSize = MySizes.bodyMedium(context); // responsive font size
    final borderRadius = MySizes.borderRadiusSm(context);

    return InputDecorationThemeData(
      fillColor: MyColors.white,
      filled: true,
      errorMaxLines: 3,
      prefixIconColor: MyColors.textPrimary,
      suffixIconColor: MyColors.textPrimary,
      iconColor: MyColors.textPrimary,
      constraints: BoxConstraints(minHeight: iconSize),
      prefixIconConstraints: BoxConstraints(
        minWidth: iconSize,
        minHeight: iconSize,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: iconSize,
        minHeight: iconSize,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding,
      ),
      labelStyle: TextStyle(fontSize: fontSize, color: MyColors.textPrimary),
      hintStyle: TextStyle(fontSize: fontSize, color: MyColors.textSecondary),
      errorStyle: const TextStyle(fontStyle: FontStyle.normal),
      floatingLabelStyle: TextStyle(
        color: MyColors.textPrimary..withValues(alpha: 0.8),
      ),
      border: _border(radius: borderRadius),
      enabledBorder: _border(radius: borderRadius),
      focusedBorder: _border(radius: borderRadius),
      errorBorder: _border(
        color: MyColors.error,
        width: 1,
        radius: borderRadius,
      ),
      focusedErrorBorder: _border(
        color: MyColors.error,
        width: 2,
        radius: borderRadius,
      ),
    );
  }

  static InputDecorationThemeData darkInputDecorationThemeData(
    BuildContext context,
  ) {
    final padding = MySizes.spaceMd(context);
    final iconSize = MySizes.spaceXl(context);
    final fontSize = MySizes.bodyMedium(context);

    return InputDecorationThemeData(
      fillColor: MyColors.primaryShade300,
      filled: true,
      errorMaxLines: 3,
      prefixIconColor: MyColors.textPrimaryDark,
      suffixIconColor: MyColors.textPrimaryDark,
      iconColor: MyColors.textPrimaryDark,
      constraints: BoxConstraints(minHeight: iconSize),
      prefixIconConstraints: BoxConstraints(
        minWidth: iconSize,
        minHeight: iconSize,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: iconSize,
        minHeight: iconSize,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding,
      ),
      labelStyle: TextStyle(
        fontSize: fontSize,
        color: MyColors.textPrimaryDark,
      ),
      hintStyle: TextStyle(fontSize: fontSize, color: MyColors.textPrimaryDark),
      errorStyle: const TextStyle(fontStyle: FontStyle.normal),
      floatingLabelStyle: TextStyle(
        color: MyColors.textPrimaryDark..withValues(alpha: 0.8),
      ),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(color: MyColors.error, width: 1),
      focusedErrorBorder: _border(color: MyColors.error, width: 2),
    );
  }
}
