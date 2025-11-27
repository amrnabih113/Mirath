import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MyTextFieldTheme {
  MyTextFieldTheme._();

  static final InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: MyColors.primaryShade700,
        suffixIconColor: MyColors.primaryShade700,
        labelStyle: const TextStyle().copyWith(
          fontSize: 14,
          color: MyColors.textPrimary,
        ),
        hintStyle: const TextStyle().copyWith(
          fontSize: 14,
          color: MyColors.primaryShade700,
        ),
        errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
        floatingLabelStyle: const TextStyle().copyWith(
          color: MyColors.textPrimary.withValues(alpha: 0.8),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      );

  static final InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: MyColors.primaryShade300,
        suffixIconColor: MyColors.primaryShade300,
        labelStyle: const TextStyle().copyWith(
          fontSize: 14,
          color: MyColors.textSecondaryDark,
        ),
        hintStyle: const TextStyle().copyWith(
          fontSize: 14,
          color: MyColors.primaryShade400,
        ),
        errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
        floatingLabelStyle: const TextStyle().copyWith(
          color: MyColors.textPrimaryDark.withValues(alpha: 0.8),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      );
}
