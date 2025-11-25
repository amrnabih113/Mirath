import 'package:flutter/material.dart';

import '../helpers/responsive_helper.dart'; // the file that has ResponsiveHelper

class MySizes {
  MySizes._(); // prevent instantiation

  /// ---------- TEXT SIZES ----------
  static double headlineLarge(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 42, tablet: 36, mobile: 30);

  static double headlineMedium(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 36, tablet: 30, mobile: 24);

  static double headlineSmall(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 30, tablet: 26, mobile: 22);

  static double titleLarge(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 26, tablet: 24, mobile: 22);

  static double titleMedium(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 24, tablet: 22, mobile: 20);

  static double titleSmall(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 22, tablet: 20, mobile: 18);

  /// ---------- BODY ----------
  static double bodyLarge(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 22, tablet: 20, mobile: 18);

  static double bodyMedium(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 20, tablet: 18, mobile: 16);

  static double bodySmall(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 18, tablet: 16, mobile: 14);

  /// ---------- ICONS ----------
  static double iconLarge(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 48.0,
    tablet: 40.0,
    mobile: 32.0,
  );

  static double iconMedium(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 40.0,
    tablet: 32.0,
    mobile: 24.0,
  );

  static double iconSmall(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 32.0,
    tablet: 24.0,
    mobile: 20.0,
  );

  /// ---------- SPACING ----------
  static double spaceXs(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 12.0,
    tablet: 10.0,
    mobile: 8.0,
  );

  static double spaceSm(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 16.0,
    tablet: 14.0,
    mobile: 12.0,
  );

  static double spaceMd(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 20.0,
    tablet: 18.0,
    mobile: 16.0,
  );

  static double spaceLg(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 32.0,
    tablet: 28.0,
    mobile: 24.0,
  );

  static double spaceXl(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 40.0,
    tablet: 36.0,
    mobile: 32.0,
  );

  /// ---------- PADDING ----------
  static EdgeInsetsGeometry paddingSm(BuildContext context) =>
      ResponsiveHelper.responsivePadding(
        context,
        web: EdgeInsets.all(20),
        tablet: EdgeInsets.all(16),
        mobile: EdgeInsets.all(12),
      );

  static EdgeInsetsGeometry paddingMd(BuildContext context) =>
      ResponsiveHelper.responsivePadding(
        context,
        web: EdgeInsets.all(32),
        tablet: EdgeInsets.all(28),
        mobile: EdgeInsets.all(24),
      );

  static EdgeInsetsGeometry paddingLg(BuildContext context) =>
      ResponsiveHelper.responsivePadding(
        context,
        web: EdgeInsets.all(40),
        tablet: EdgeInsets.all(36),
        mobile: EdgeInsets.all(32),
      );

  /// ---------- BUTTON ----------
  static double buttonHeight(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 72.0,
        tablet: 64.0,
        mobile: 56.0,
      );

  static double buttonWidth(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 240.0,
        tablet: 200.0,
        mobile: 160.0,
      );

  /// ---------- RADIUS ----------
  static double borderRadiusSm(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 16.0,
        tablet: 14.0,
        mobile: 12.0,
      );

  static double borderRadiusMd(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 20.0,
        tablet: 16.0,
        mobile: 14.0,
      );

  static double borderRadiusLg(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 24.0,
        tablet: 20.0,
        mobile: 16.0,
      );

  /// ---------- IMAGE SIZES ----------
  static double imageXl(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 480.0,
    tablet: 400.0,
    mobile: 400.0,
  );

  static double imageLarge(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 400.0,
    tablet: 320.0,
    mobile: 280.0,
  );

  static double imageMedium(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 280.0,
        tablet: 240.0,
        mobile: 220.0,
      );

  static double imageSmall(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 200.0,
    tablet: 180.0,
    mobile: 160.0,
  );
}
