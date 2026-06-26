import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class AccountTiles extends StatelessWidget {
  const AccountTiles({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.btnName,
    this.subtitleWidget,
    this.textColor,
    this.titleWidget,
    this.isClicked = false,
    this.buttonIcon,
  });
  final List<List<dynamic>>? icon;
  final List<List<dynamic>>? buttonIcon;
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? btnName;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool isClicked;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null
          ? HugeIcon(icon: icon!, size: MySizes.iconMedium(context))
          : null,
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: context.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null),

      subtitle:
          subtitleWidget ??
          (subtitle != null
              ? Text(
                  subtitle!,
                  style: context.bodyLarge.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: MyColors.darkerGrey,
                  ),
                )
              : null),
      trailing: btnName != null
          ? TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(64, 28),
                backgroundColor: isClicked
                    ? MyColors.primaryShade900
                    : Colors.transparent,
                side: BorderSide(color: MyColors.primaryShade900, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              onPressed: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    btnName ?? '',
                    style: context.bodyLarge.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isClicked
                          ? MyColors.primaryShade200
                          : textColor ?? MyColors.primaryShade900,
                    ),
                  ),

                  if (buttonIcon != null) ...[
                    const SizedBox(width: 4),
                    HugeIcon(
                      icon: buttonIcon!,
                      size: MySizes.iconSmall(context),
                    ),
                  ],
                ],
              ),
            )
          : null,
    );
  }
}
