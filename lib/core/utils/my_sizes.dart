import 'package:flutter/material.dart';

import '../helpers/responsive_helper.dart'; // the file that has ResponsiveHelper

class MySizes {
  MySizes._(); // prevent instantiation

  /// ---------- TEXT SIZES ----------
  static double headlineLarge(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 36, tablet: 30, mobile: 24);

  static double headlineMedium(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 30, tablet: 26, mobile: 20);

  static double headlineSmall(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 26, tablet: 22, mobile: 18);

  static double titleLarge(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 22, tablet: 20, mobile: 18);

  static double titleMedium(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 20, tablet: 18, mobile: 16);

  static double titleSmall(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 18, tablet: 16, mobile: 14);

  /// ---------- BODY ----------
  static double bodyLarge(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 18, tablet: 16, mobile: 14);

  static double bodyMedium(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 16, tablet: 14, mobile: 12);

  static double bodySmall(BuildContext context) =>
      ResponsiveHelper.responsiveText(context, web: 14, tablet: 12, mobile: 10);

  /// ---------- ICONS ----------
  static double iconLarge(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 40.0,
    tablet: 32.0,
    mobile: 24.0,
  );

  static double iconMedium(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 32.0,
    tablet: 28.0,
    mobile: 20.0,
  );

  static double iconSmall(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 24.0,
    tablet: 20.0,
    mobile: 16.0,
  );

  /// ---------- SPACING ----------
  static double spaceXs(BuildContext context) =>
      ResponsiveHelper.responsive(context, web: 8.0, tablet: 6.0, mobile: 4.0);

  static double spaceSm(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 12.0,
    tablet: 10.0,
    mobile: 8.0,
  );

  static double spaceMd(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 16.0,
    tablet: 14.0,
    mobile: 12.0,
  );

  static double spaceLg(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 24.0,
    tablet: 20.0,
    mobile: 16.0,
  );

  static double spaceXl(BuildContext context) => ResponsiveHelper.responsive(
    context,
    web: 32.0,
    tablet: 28.0,
    mobile: 24.0,
  );

  /// ---------- PADDING ----------
  static EdgeInsetsGeometry paddingSm(BuildContext context) =>
      ResponsiveHelper.responsivePadding(
        context,
        web: EdgeInsets.all(16),
        tablet: EdgeInsets.all(12),
        mobile: EdgeInsets.all(8),
      );

  static EdgeInsetsGeometry paddingMd(BuildContext context) =>
      ResponsiveHelper.responsivePadding(
        context,
        web: EdgeInsets.all(24),
        tablet: EdgeInsets.all(20),
        mobile: EdgeInsets.all(16),
      );

  static EdgeInsetsGeometry paddingLg(BuildContext context) =>
      ResponsiveHelper.responsivePadding(
        context,
        web: EdgeInsets.all(32),
        tablet: EdgeInsets.all(28),
        mobile: EdgeInsets.all(24),
      );

  /// ---------- BUTTON ----------
  static double buttonHeight(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 60.0,
        tablet: 54.0,
        mobile: 48.0,
      );

  static double buttonWidth(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 200.0,
        tablet: 160.0,
        mobile: 120.0,
      );

  /// ---------- RADIUS ----------
  static double borderRadiusSm(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 12.0,
        tablet: 10.0,
        mobile: 8.0,
      );

  static double borderRadiusMd(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 16.0,
        tablet: 12.0,
        mobile: 10.0,
      );

  static double borderRadiusLg(BuildContext context) =>
      ResponsiveHelper.responsive(
        context,
        web: 20.0,
        tablet: 16.0,
        mobile: 12.0,
      );
}
