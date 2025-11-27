import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MyTextFieldTheme {
  MyTextFieldTheme._();

  static final InputDecorationTheme
  lightInputDecorationTheme = InputDecorationTheme(
    fillColor: MyColors.primaryShade300,
    filled: true,
    errorMaxLines: 3,
    prefixIconColor: MyColors.textPrimary,
    suffixIconColor: MyColors.textPrimary,
    iconColor: MyColors.textPrimary,
    constraints: const BoxConstraints(minHeight: 56),
    prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    labelStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: MyColors.textPrimary,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: MyColors.textSecondary,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: MyColors.textPrimary.withValues(alpha: 0.8),
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
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: MyColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: MyColors.error, width: 2),
    ),
  );

  static final InputDecorationTheme
  darkInputDecorationTheme = InputDecorationTheme(
    fillColor: MyColors.primaryShade300,
    filled: true,
    errorMaxLines: 3,
    prefixIconColor: MyColors.textPrimaryDark,
    suffixIconColor: MyColors.textPrimaryDark,
    iconColor: MyColors.textPrimaryDark,
    constraints: const BoxConstraints(minHeight: 56),
    prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    labelStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: MyColors.textPrimary,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: MyColors.textPrimary,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: MyColors.textPrimary.withValues(alpha: 0.8),
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
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: MyColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: MyColors.error, width: 2),
    ),
  );
}
