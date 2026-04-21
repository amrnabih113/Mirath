import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class ReadLaterContainer extends StatelessWidget {
  const ReadLaterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/read-later');
      },
      child: Container(
        height: 100,
        width: MySizes.screenWidth(context),
        padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(context, 16)),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 16),
          ),
          border: Border.all(color: MyColors.primaryShade800, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Read Later',
              style: context.headlineSmall.copyWith(
                color: MyColors.primaryShade900,
                fontWeight: FontWeight.w700,
                height: 1.3,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context) * 0.5),
            Text('8 papers • Updated 2 days ago'),
          ],
        ),
      ),
    );
  }
}
