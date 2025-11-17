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
        color: Colors.white,
      ),
      headlineMedium: font(
        fontSize: MySizes.headlineMedium(context),
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineSmall: font(
        fontSize: MySizes.headlineSmall(context),
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleLarge: font(
        fontSize: MySizes.titleLarge(context),
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: font(
        fontSize: MySizes.titleMedium(context),
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleSmall: font(
        fontSize: MySizes.titleSmall(context),
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: font(
        fontSize: MySizes.bodyLarge(context),
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      bodyMedium: font(
        fontSize: MySizes.bodyMedium(context),
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      bodySmall: font(
        fontSize: MySizes.bodySmall(context),
        fontWeight: FontWeight.w500,
        color: Colors.white70.withValues(alpha: 0.5),
      ),
      labelLarge: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      labelMedium: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: Colors.white70.withValues(alpha: 0.5),
      ),
      labelSmall: font(
        fontSize: MySizes.titleSmall(context) - 2,
        fontWeight: FontWeight.normal,
        color: Colors.white70.withValues(alpha: 0.5),
      ),
    );
  }
}
