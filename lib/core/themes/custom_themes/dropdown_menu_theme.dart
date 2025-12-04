import 'package:flutter/material.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_sizes.dart';

class MyDropdownMenuTheme {
  MyDropdownMenuTheme._();

  // ==================== DROPDOWN MENU THEME ====================
  static DropdownMenuThemeData lightDropdownMenuTheme(BuildContext context) {
    final padding = MySizes.spaceMd(context);
    final iconSize = MySizes.spaceXl(context);
    final fontSize = MySizes.bodyMedium(context);

    return DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(MyColors.primaryShade200),
        elevation: WidgetStateProperty.all(8),
        shadowColor: WidgetStateProperty.all(
          MyColors.textPrimary.withOpacity(0.1),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: MySizes.spaceXs(context)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColors.error, width: 2),
        ),
      ),
      textStyle: TextStyle(fontSize: fontSize, color: MyColors.textPrimary),
    );
  }

  static DropdownMenuThemeData darkDropdownMenuTheme(BuildContext context) {
    final padding = MySizes.spaceMd(context);
    final iconSize = MySizes.spaceXl(context);
    final fontSize = MySizes.bodyMedium(context);

    return DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(MyColors.primaryShade600),
        elevation: WidgetStateProperty.all(8),
        shadowColor: WidgetStateProperty.all(MyColors.black.withOpacity(0.3)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: MySizes.spaceXs(context)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: MyColors.primaryShade700.withOpacity(0.2),
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
        hintStyle: TextStyle(
          fontSize: fontSize,
          color: MyColors.textSecondaryDark,
        ),
        errorStyle: const TextStyle(fontStyle: FontStyle.normal),
        floatingLabelStyle: TextStyle(
          color: MyColors.textPrimaryDark.withOpacity(0.8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColors.error, width: 2),
        ),
      ),
      textStyle: TextStyle(fontSize: fontSize, color: MyColors.textPrimaryDark),
    );
  }

  // ==================== POPUP MENU THEME (for DropdownButton) ====================
  static PopupMenuThemeData lightPopupMenuTheme(BuildContext context) {
    return PopupMenuThemeData(
      color: MyColors.primaryShade400,
      elevation: 8,
      shadowColor: MyColors.textPrimary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(
        fontSize: MySizes.bodyMedium(context),
        color: MyColors.textPrimary,
      ),
    );
  }

  static PopupMenuThemeData darkPopupMenuTheme(BuildContext context) {
    return PopupMenuThemeData(
      color: MyColors.primaryShade600,
      elevation: 8,
      shadowColor: MyColors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(
        fontSize: MySizes.bodyMedium(context),
        color: MyColors.textPrimaryDark,
      ),
    );
  }

  // ==================== MENU ITEM THEME ====================
  static MenuThemeData lightMenuTheme(BuildContext context) {
    return MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return MyColors.primaryShade400;
          }
          if (states.contains(WidgetState.focused)) {
            return MyColors.primaryShade400;
          }
          return MyColors.primaryShade400;
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: MySizes.spaceMd(context),
            vertical: MySizes.spaceXs(context),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
    );
  }

  static MenuThemeData darkMenuTheme(BuildContext context) {
    return MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return MyColors.primaryShade500;
          }
          if (states.contains(WidgetState.focused)) {
            return MyColors.primaryShade500;
          }
          return MyColors.primaryShade600;
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: MySizes.spaceMd(context),
            vertical: MySizes.spaceXs(context),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
    );
  }
}
