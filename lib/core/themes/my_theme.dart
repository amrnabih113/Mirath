import 'package:flutter/material.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/dropdown_menu_theme.dart';
import 'custom_themes/elevation_button_theme.dart';
import 'custom_themes/outlined_buttom_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';
import '../utils/my_colors.dart';

class MyTheme {
  MyTheme._();

  static ThemeData lightTheme(BuildContext context, Locale? locale) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: MyColors.primaryColor,
      scaffoldBackgroundColor: MyColors.light,
      textTheme: MyTextTheme.getLightTextTheme(context, locale),
      appBarTheme: MyAppBarTheme.lightAppBarTheme,
      bottomSheetTheme: MyBottomSheetTheme.lightBottomSheetTheme,
      checkboxTheme: MyCheckboxTheme.lightCheckboxTheme,
      chipTheme: MyChipTheme.lightChipTheme,
      elevatedButtonTheme: MyElevationButtonTheme.lightElevatedButtonTheme(
        context,
      ),
      outlinedButtonTheme: MyOutlinedButtonTheme.lightTheme,
      inputDecorationTheme: MyTextFieldTheme.lightInputDecorationThemeData(
        context,
      ),
      dropdownMenuTheme: MyDropdownMenuTheme.lightDropdownMenuTheme(context),
      popupMenuTheme: MyDropdownMenuTheme.lightPopupMenuTheme(context),
      menuTheme: MyDropdownMenuTheme.lightMenuTheme(context),
    );
  }

  static ThemeData darkTheme(BuildContext context, Locale? locale) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: MyColors.primaryColor,
      scaffoldBackgroundColor: MyColors.dark,
      textTheme: MyTextTheme.getDarkTextTheme(context, locale),
      appBarTheme: MyAppBarTheme.darkAppBarTheme,
      bottomSheetTheme: MyBottomSheetTheme.darkBottomSheetTheme,
      checkboxTheme: MyCheckboxTheme.darkCheckboxTheme,
      chipTheme: MyChipTheme.darkChipTheme,
      elevatedButtonTheme: MyElevationButtonTheme.darkElevatedButtonTheme(
        context,
      ),
      outlinedButtonTheme: MyOutlinedButtonTheme.darkTheme,
      inputDecorationTheme: MyTextFieldTheme.darkInputDecorationThemeData(
        context,
      ),
      dropdownMenuTheme: MyDropdownMenuTheme.darkDropdownMenuTheme(context),
      popupMenuTheme: MyDropdownMenuTheme.darkPopupMenuTheme(context),
      menuTheme: MyDropdownMenuTheme.darkMenuTheme(context),
    );
  }
}
