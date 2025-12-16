import 'package:flutter/material.dart';

import '../helpers/responsive_helper.dart';

class MySizes {
  MySizes._();

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// ---------- TEXT SIZES ----------
  static double headlineLarge(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 30); // 32 → 30

  static double headlineMedium(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 26); // 28 → 26

  static double headlineSmall(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 22); // 24 → 22

  static double titleLarge(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 20); // 22 → 20

  static double titleMedium(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 18); // 20 → 18

  static double titleSmall(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 16); // 18 → 16

  /// ---------- BODY ----------
  static double bodyLarge(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 16); // 18 → 16

  static double bodyMedium(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 14); // 16 → 14

  static double bodySmall(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 13); // 14 → 13

  /// ---------- ICONS ----------
  static double iconLarge(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 36); // 40 → 36

  static double iconMedium(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 26); // 28 → 26

  static double iconSmall(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 22); // 24 → 22

  /// ---------- SPACING ----------
  static double spaceXs(BuildContext context) =>
      ResponsiveHelper.responsiveGap(context, 7); // 8 → 7

  static double spaceSm(BuildContext context) =>
      ResponsiveHelper.responsiveGap(context, 11); // 12 → 11

  static double spaceMd(BuildContext context) =>
      ResponsiveHelper.responsiveGap(context, 14); // 16 → 14

  static double spaceLg(BuildContext context) =>
      ResponsiveHelper.responsiveGap(context, 22); // 24 → 22

  static double spaceXl(BuildContext context) =>
      ResponsiveHelper.responsiveGap(context, 30); // 32 → 30

  /// ---------- PADDING ----------
  static EdgeInsets paddingSm(BuildContext context) =>
      ResponsiveHelper.responsivePadding(context, 11); // 12 → 11

  static EdgeInsets paddingMd(BuildContext context) =>
      ResponsiveHelper.responsivePadding(context, 18); // 20 → 18

  static EdgeInsets paddingLg(BuildContext context) =>
      ResponsiveHelper.responsivePadding(context, 26); // 28 → 26

  /// ---------- BUTTON ----------
  static double buttonHeight(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 52); // 56 → 52

  static double buttonWidth(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 160); // 200 → 190

  /// ---------- RADIUS ----------
  static double borderRadiusSm(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 11); // 12 → 11

  static double borderRadiusMd(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 15); // 16 → 15

  static double borderRadiusLg(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 18); // 20 → 18

  /// ---------- IMAGE SIZES ----------
  static double imageXl(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 400); // 420 → 400

  static double imageLarge(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 330); // 350 → 330

  static double imageMedium(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 240); // 250 → 240

  static double imageSmall(BuildContext context) =>
      ResponsiveHelper.responsiveValue(context, 170); // 180 → 170
}
