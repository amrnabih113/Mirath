import 'package:flutter/widgets.dart';

enum DeviceType { smallPhone, phone, tablet, largeTablet, desktop }

class ResponsiveHelper {
  ResponsiveHelper._();

  /// Determine device type using width
  static DeviceType deviceTypeFromContext(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w >= 1200) return DeviceType.desktop; // Large web screens
    if (w >= 900) return DeviceType.largeTablet; // Large tablets / iPad Pro
    if (w >= 600) return DeviceType.tablet; // Tablets
    if (w >= 360) return DeviceType.phone; // Normal phones
    return DeviceType.smallPhone; // Very small phones
  }

  /// Scale factor based on width and height (for better tall screen support)
  static double scale(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    double widthScale;
    switch (deviceTypeFromContext(context)) {
      case DeviceType.smallPhone:
        widthScale = 0.85;
        break;
      case DeviceType.phone:
        widthScale = 1;
        break;
      case DeviceType.tablet:
        widthScale = 1.15;
        break;
      case DeviceType.largeTablet:
        widthScale = 1.4;
        break;
      case DeviceType.desktop:
        widthScale = 1.35;
        break;
    }

    // Also consider height scaling
    double heightScale = (h / 800).clamp(0.8, 1.5);

    return widthScale * heightScale;
  }

  /// General responsive value
  static double responsiveValue(BuildContext context, double baseValue) {
    return baseValue * scale(context);
  }

  /// Responsive padding
  static EdgeInsets responsivePadding(BuildContext context, double base) {
    final s = scale(context);
    return EdgeInsets.all(base * s);
  }

  /// Responsive GAP (reduces on short screens, increases on tall screens)
  static double responsiveGap(BuildContext context, double baseGap) {
    final h = MediaQuery.of(context).size.height;
    double scaled = baseGap * scale(context);

    if (h < 650) return scaled * 0.25; // very small screens
    if (h < 750) return scaled * 0.5; // small phones

    return scaled; // normal / tall screens
  }
}
