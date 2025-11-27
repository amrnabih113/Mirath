import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_sizes.dart';

class MyTextTheme {
  MyTextTheme._();

  static TextTheme getLightTextTheme(BuildContext context, Locale? locale) {
    final isArabic = locale?.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.balooBhai2 : GoogleFonts.roboto;

    return TextTheme(
      headlineLarge: font(
        fontSize: MySizes.headlineLarge(context),
        fontWeight: FontWeight.bold,
        color: MyColors.textPrimary,
      ),
      headlineMedium: font(
        fontSize: MySizes.headlineMedium(context),
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
      ),
      headlineSmall: font(
        fontSize: MySizes.headlineSmall(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textPrimary,
      ),
      titleLarge: font(
        fontSize: MySizes.titleLarge(context),
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
      ),
      titleMedium: font(
        fontSize: MySizes.titleMedium(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textPrimary,
      ),
      titleSmall: font(
        fontSize: MySizes.titleSmall(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textPrimary,
      ),
      bodyLarge: font(
        fontSize: MySizes.bodyLarge(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondary,
      ),
      bodyMedium: font(
        fontSize: MySizes.bodyMedium(context),
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondary,
      ),
      bodySmall: font(
        fontSize: MySizes.bodySmall(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondary.withValues(alpha: 0.5),
      ),
      labelLarge: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: MyColors.textPrimary,
      ),
      labelMedium: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: MyColors.textPrimary.withValues(alpha: 0.5),
      ),
      labelSmall: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: MyColors.textPrimary.withValues(alpha: 0.5),
      ),
    );
  }

  static TextTheme getDarkTextTheme(BuildContext context, Locale? locale) {
    final isArabic = locale?.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.balooBhai2 : GoogleFonts.roboto;

    return TextTheme(
      headlineLarge: font(
        fontSize: MySizes.headlineLarge(context),
        fontWeight: FontWeight.bold,
        color: MyColors.textPrimaryDark,
      ),
      headlineMedium: font(
        fontSize: MySizes.headlineMedium(context),
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimaryDark,
      ),
      headlineSmall: font(
        fontSize: MySizes.headlineSmall(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textPrimaryDark,
      ),
      titleLarge: font(
        fontSize: MySizes.titleLarge(context),
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimaryDark,
      ),
      titleMedium: font(
        fontSize: MySizes.titleMedium(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textPrimaryDark,
      ),
      titleSmall: font(
        fontSize: MySizes.titleSmall(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textPrimaryDark,
      ),
      bodyLarge: font(
        fontSize: MySizes.bodyLarge(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondaryDark,
      ),
      bodyMedium: font(
        fontSize: MySizes.bodyMedium(context),
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondaryDark,
      ),
      bodySmall: font(
        fontSize: MySizes.bodySmall(context),
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondaryDark.withValues(alpha: 0.6),
      ),
      labelLarge: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondaryDark,
      ),
      labelMedium: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondaryDark.withValues(alpha: 0.7),
      ),
      labelSmall: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondaryDark.withValues(alpha: 0.6),
      ),
    );
  }
}
