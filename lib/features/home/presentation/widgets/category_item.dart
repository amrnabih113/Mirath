import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class CategoryItem extends StatefulWidget {
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
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: ResponsiveHelper.responsiveValue(context, 8),
        ),
        height: ResponsiveHelper.responsiveValue(context, 35),
        decoration: BoxDecoration(
          color: widget.isSelected ? MyColors.primaryShade100 : MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
          border: Border.all(
            color: widget.isSelected
                ? MyColors.primaryShade300
                : MyColors.primaryShade100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? MyColors.primaryShade900.withValues(
                      alpha: _isPressed ? 0.16 : 0.12,
                    )
                  : MyColors.primaryShade900.withValues(
                      alpha: _isPressed ? 0.08 : 0.06,
                    ),
              blurRadius: widget.isSelected ? 8 : 6,
              offset: Offset(
                0,
                ResponsiveHelper.responsiveValue(context, _isPressed ? 1 : 2),
              ),
              spreadRadius: 0,
            ),
          ],
        ),
        transform: Matrix4.translationValues(
          0,
          ResponsiveHelper.responsiveValue(context, _isPressed ? 1 : 0),
          0,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MySizes.spaceSm(context)),
            child: Text(
              widget.categoryName,
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade900,
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveHelper.responsiveValue(context, 12),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
