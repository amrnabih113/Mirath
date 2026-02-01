import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';

class AddDiscussionTagChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const AddDiscussionTagChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.bodySmall.copyWith(
              fontSize: ResponsiveHelper.responsiveValue(context, 11.5),
              color: MyColors.primaryShade900,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(width: ResponsiveHelper.responsiveValue(context, 4)),
          GestureDetector(
            onTap: onRemove,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCancel01,
              size: ResponsiveHelper.responsiveValue(context, 14),
              color: MyColors.primaryShade900,
            ),
          ),
        ],
      ),
    );
  }
}
