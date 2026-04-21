import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_sizes.dart';

import '../../../core/helpers/responsive_helper.dart';
import '../../../core/utils/my_colors.dart';
import '../../../core/utils/my_extenstions.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool? hasIcon;
  const TagChip({super.key, required this.label, this.hasIcon = false});

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
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: context.bodySmall.copyWith(
                fontSize: ResponsiveHelper.responsiveValue(context, 11.5),
                color: MyColors.primaryShade900,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            WidgetSpan(child: SizedBox(width: MySizes.spaceXs(context))),
            if (hasIcon!)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
