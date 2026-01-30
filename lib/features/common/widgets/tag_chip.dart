import 'package:flutter/material.dart';

import '../../../core/helpers/responsive_helper.dart';
import '../../../core/utils/my_colors.dart';
import '../../../core/utils/my_extenstions.dart';

class TagChip extends StatelessWidget {
  final String label;
  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(context, 12),
        vertical: ResponsiveHelper.responsiveValue(context, 6),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryShade200.withValues(alpha: 0.4),
            MyColors.primaryShade300.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 8),
        ),
      ),
      child: Text(
        label,
        style: context.bodySmall.copyWith(
          fontSize: ResponsiveHelper.responsiveValue(context, 11.5),
          color: MyColors.primaryShade900,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
