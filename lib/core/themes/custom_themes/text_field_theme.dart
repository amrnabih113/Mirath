import 'package:flutter/material.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_sizes.dart'; // your responsive helper

class MyTextFieldTheme {
  MyTextFieldTheme._();

  static OutlineInputBorder _border({Color? color, double width = 0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color ?? Colors.transparent, width: width),
    );
  }

  static InputDecorationThemeData lightInputDecorationThemeData(
    BuildContext context,
  ) {
    final padding = MySizes.spaceMd(context); // example responsive padding
    final iconSize = MySizes.spaceXl(context); // example icon size
    final fontSize = MySizes.bodyMedium(context); // responsive font size

    return InputDecorationThemeData(
      fillColor: MyColors.primaryShade300,
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
        color: MyColors.textPrimary.withOpacity(0.8),
      ),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(color: MyColors.error, width: 1),
      focusedErrorBorder: _border(color: MyColors.error, width: 2),
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
        color: MyColors.textPrimaryDark.withOpacity(0.8),
      ),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(color: MyColors.error, width: 1),
      focusedErrorBorder: _border(color: MyColors.error, width: 2),
    );
  }
}
