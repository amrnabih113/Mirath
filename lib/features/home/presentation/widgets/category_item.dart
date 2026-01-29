import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.categoryName,
    this.onTap,
    this.isSelected = false,
  });
  final String categoryName;
  final VoidCallback? onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: ResponsiveHelper.responsiveValue(context, 8),
        ),
        height: ResponsiveHelper.responsiveValue(context, 35),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? MyColors.primaryShade700
                : MyColors.primaryShade600,
          ),
          color: isSelected
              ? MyColors.primaryShade500
              : MyColors.primaryShade100,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
        ),

        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MySizes.spaceSm(context)),
            child: Text(
              categoryName,
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade900,
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveHelper.responsiveValue(context, 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
