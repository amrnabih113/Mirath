import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/my_helper_functions.dart';
import '../../../core/utils/my_colors.dart';
import '../../../core/helpers/responsive_helper.dart';

class ScreenDecoration extends StatelessWidget {
  const ScreenDecoration({super.key, required this.child, this.dark = true});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);

    // Make circles responsive
    final largeCircleSize = ResponsiveHelper.responsiveValue(context, 635);
    final smallCircleSize = ResponsiveHelper.responsiveValue(context, 496);

    final largeCircleLeft = ResponsiveHelper.responsiveValue(context, 148);
    final largeCircleTop = ResponsiveHelper.responsiveValue(context, -327);

    final smallCircleLeft = ResponsiveHelper.responsiveValue(context, 57);
    final smallCircleTop = ResponsiveHelper.responsiveValue(context, -142);

    return Stack(
      children: [
        Positioned(
          left: largeCircleLeft,
          top: largeCircleTop,
          child: Container(
            width: largeCircleSize,
            height: largeCircleSize,
            decoration: ShapeDecoration(
              color: dark
                  ? const Color(0x7F6F604E)
                  : isDark
                  ? MyColors.primaryShade900
                  : MyColors.primaryShade50,
              shape: const OvalBorder(),
            ),
          ),
        ),
        Positioned(
          left: smallCircleLeft,
          top: smallCircleTop,
          child: Container(
            width: smallCircleSize,
            height: smallCircleSize,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width: ResponsiveHelper.responsiveValue(context, 3),
                  color: dark
                      ? const Color(0x7F6F604E)
                      : isDark
                      ? MyColors.primaryShade900
                      : MyColors.primaryShade50,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
