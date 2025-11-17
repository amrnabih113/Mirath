import 'package:flutter/widgets.dart';

import '../utils/my_enums.dart';

const double _tabletMinWidth = 600; // >= 600 -> tablet
const double _webMinWidth = 1024; // >= 1024 -> web

/// Returns the device type based on the available width.
DeviceType deviceTypeFromContext(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w >= _webMinWidth) return DeviceType.web;
  if (w >= _tabletMinWidth) return DeviceType.tablet;
  return DeviceType.mobile;
}

class ResponsiveHelper {
  ResponsiveHelper._();

  /// Choose a value depending on the device: [webValue], [tabletValue], [mobileValue].
  ///
  /// Example: `ResponsiveHelper.responsive(context, web: 24.0, tablet: 20.0, mobile: 16.0)`
  static T responsive<T>(
    BuildContext context, {
    required T web,
    required T tablet,
    required T mobile,
  }) {
    switch (deviceTypeFromContext(context)) {
      case DeviceType.web:
        return web;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.mobile:
        return mobile;
    }
    // All DeviceType cases return above; no-op here.
  }

  /// Responsive padding example that scales with shortestSide.
  static EdgeInsetsGeometry responsivePadding(
    BuildContext context, {
    EdgeInsetsGeometry? web,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? mobile,
  }) {
    return responsive<EdgeInsetsGeometry>(
      context,
      web: web ?? const EdgeInsets.all(24),
      tablet: tablet ?? const EdgeInsets.all(16),
      mobile: mobile ?? const EdgeInsets.all(12),
    );
  }

  /// Responsive text size helper using a base size then scaling per device.
  static double responsiveText(
    BuildContext context, {
    required double web,
    required double tablet,
    required double mobile,
  }) {
    return responsive<double>(
      context,
      web: web,
      tablet: tablet,
      mobile: mobile,
    );
  }

  /// Helper to check if layout should be treated as compact (mobile) or expanded (tablet/web).
  static bool isCompact(BuildContext context) =>
      deviceTypeFromContext(context) == DeviceType.mobile;
}
