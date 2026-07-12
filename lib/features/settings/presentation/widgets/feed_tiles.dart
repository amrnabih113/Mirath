import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class FeedTiles extends StatelessWidget {
  const FeedTiles({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final List<List<dynamic>>? icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon != null
          ? HugeIcon(icon: icon!, size: MySizes.iconMedium(context))
          : null,
      title: Text(
        title,
        style: context.labelLarge.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Text(
        subtitle,
        style: context.bodyLarge.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyColors.darkerGrey,
        ),
      ),
      trailing: trailing,
    );
  }
}
