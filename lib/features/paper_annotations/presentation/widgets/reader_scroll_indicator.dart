import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class ReaderScrollIndicator extends StatelessWidget {
  final double progress;

  const ReaderScrollIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      borderRadius: BorderRadius.circular(MySizes.borderRadiusLg(context)),
      stopIndicatorRadius: MySizes.spaceSm(context),
      minHeight: ResponsiveHelper.responsiveValue(context, 20),
      backgroundColor: MyColors.primaryShade900.withValues(alpha: 0.2),
      valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryShade700),
    );
  }
}
