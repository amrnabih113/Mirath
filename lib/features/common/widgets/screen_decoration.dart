import 'package:flutter/material.dart';

import '../../../core/helpers/my_helper_functions.dart';
import '../../../core/helpers/responsive_helper.dart';
import '../../../core/utils/my_colors.dart';

class ScreenDecoration extends StatelessWidget {
  const ScreenDecoration({super.key, required this.child, this.dark = true});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);

    final isWeb =
        ResponsiveHelper.deviceTypeFromContext(context) == DeviceType.desktop;

    // Responsive sizes (unchanged)
    final largeCircleSize = ResponsiveHelper.responsiveValue(context, 635);
    final smallCircleSize = ResponsiveHelper.responsiveValue(context, 496);

    final largeCircleOffsetX = ResponsiveHelper.responsiveValue(context, 148);
    final largeCircleTop = ResponsiveHelper.responsiveValue(context, -327);

    final smallCircleOffsetX = ResponsiveHelper.responsiveValue(context, 57);
    final smallCircleTop = ResponsiveHelper.responsiveValue(context, -142);

    final circleColor = dark
        ? const Color(0x7F6F604E)
        : isDark
        ? MyColors.primaryShade900
        : MyColors.lightCircle;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// LARGE CIRCLE
        Positioned(
          top: largeCircleTop,
          left: isWeb ? largeCircleOffsetX * 5 : largeCircleOffsetX,
          child: Container(
            width: largeCircleSize,
            height: largeCircleSize,
            decoration: ShapeDecoration(
              color: circleColor,
              shape: const OvalBorder(),
            ),
          ),
        ),

        /// SMALL CIRCLE (OUTLINE)
        Positioned(
          top: isWeb ? smallCircleTop * 0.6 : smallCircleTop,
          left: isWeb ? smallCircleOffsetX * 12.5 : smallCircleOffsetX,
          child: Container(
            width: smallCircleSize,
            height: smallCircleSize,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width: ResponsiveHelper.responsiveValue(context, 3),
                  color: circleColor,
                ),
              ),
            ),
          ),
        ),

        /// CONTENT
        Positioned.fill(
          child: Align(alignment: Alignment.topLeft, child: child),
        ),
      ],
    );
  }
}
