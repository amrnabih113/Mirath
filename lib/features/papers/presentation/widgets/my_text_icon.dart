import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.title,
    required this.titleColor,
    required this.buttonColor,
    this.shape,
    this.icon,
    this.hasIcon = false,
  });
  final String title;
  final Color titleColor;
  final Color buttonColor;
  final OutlinedBorder? shape;
  final IconData? icon;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(
          MySizes.buttonWidth(context) * 1.15,
          MySizes.buttonHeight(context) * .66,
        ),
        padding: MySizes.paddingSm(context),
        side: BorderSide(
          color: MyColors.primaryShade800,
          width: MySizes.borderRadiusSm(context) * .1,
        ),
        shape: shape,
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hasIcon ? Icon(icon, color: MyColors.textWhite) : SizedBox(),
            SizedBox(width: MySizes.spaceXs(context)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(
                color: titleColor,
                fontSize: ResponsiveHelper.responsiveValue(context, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
