import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/my_helper_functions.dart';

import '../../../core/utils/my_colors.dart';

class ScreenDecoration extends StatelessWidget {
  const ScreenDecoration({super.key, required this.child, this.dark = true});
  final Widget child;
  final bool dark;
  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        Positioned(
          left: 148,
          top: -327,
          child: Container(
            width: 635,
            height: 635,
            decoration: ShapeDecoration(
              color: dark
                  ? const Color(0x7F6F604E) /* Circle-color-dark */
                  : isDark
                  ? MyColors.primaryShade900
                  : MyColors.primaryShade100 /* Circle-color-light */,
              shape: OvalBorder(),
            ),
          ),
        ),
        Positioned(
          left: 57,
          top: -142,
          child: Container(
            width: 496,
            height: 496,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width: 3,
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
