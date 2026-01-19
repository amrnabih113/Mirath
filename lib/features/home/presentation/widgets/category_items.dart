import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          right: ResponsiveHelper.responsiveValue(context, 8),
        ),
        height: ResponsiveHelper.responsiveValue(context, 40),
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.primaryShade600),
          color: MyColors.primaryShade200,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
        ),

        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MySizes.spaceSm(context)),
            child: Text(
              'Computer Science',
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
