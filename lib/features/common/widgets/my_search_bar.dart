import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/utils/my_colors.dart';
import '../../../core/utils/my_extenstions.dart';
import '../../../core/utils/my_sizes.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.showSuffixIcon = false,
    this.onSuffixIconTap,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
  });
  final TextEditingController controller;
  final String hintText;
  final bool showSuffixIcon;
  final void Function()? onSuffixIconTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool? readOnly;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryShade900.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(4, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        readOnly: readOnly ?? false,
        onTap: onTap,
        cursorColor: MyColors.primaryShade500,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.bodySmall.copyWith(
            color: MyColors.textSecondary.withAlpha(120),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: MySizes.spaceSm(context),
            horizontal: MySizes.spaceMd(context),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: MySizes.iconSmall(context) * 2,
            minHeight: MySizes.iconSmall(context) * 2,
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: MySizes.iconSmall(context) * 2,
            minHeight: MySizes.iconSmall(context) * 2,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: MySizes.spaceSm(context),
              right: MySizes.spaceXs(context),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: MyColors.textSecondary,
            ),
          ),
          suffixIcon: showSuffixIcon
              ? IconButton(
                  onPressed: () {},
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedCamera01),
                )
              : null,
          filled: true,
          fillColor: MyColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MySizes.borderRadiusMd(context),
            ),
            borderSide: BorderSide(color: MyColors.primaryShade50, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MySizes.borderRadiusMd(context),
            ),
            borderSide: BorderSide(color: MyColors.primaryShade500, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MySizes.borderRadiusMd(context),
            ),
            borderSide: BorderSide(color: MyColors.primaryShade50, width: 1),
          ),
        ),
      ),
    );
  }
}
