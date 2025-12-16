import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.showSuffixIcon = false,
    this.onSuffixIconTap,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hintText;
  final bool showSuffixIcon;
  final void Function()? onSuffixIconTap;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: MyColors.primaryColor,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.bodySmall.copyWith(
          color: MyColors.textSecondary.withAlpha(90),
          fontSize: MySizes.bodySmall(context) * 0.9,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: MySizes.iconSmall(context) * 2,
          minHeight: MySizes.iconSmall(context) * 2,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: MySizes.spaceMd(context),
            right: MySizes.spaceSm(context),
          ),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,

            color: MyColors.textSecondary,
          ),
        ),
        filled: true,
        fillColor: MyColors.primaryShade300,
        contentPadding: EdgeInsets.symmetric(
          vertical: MySizes.spaceMd(context),
          horizontal: MySizes.spaceMd(context),
        ),
        suffixIcon: showSuffixIcon
            ? Padding(
                padding: EdgeInsets.only(right: MySizes.spaceMd(context)),
                child: InkWell(
                  onTap: onSuffixIconTap,
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCamera01,
                    size: MySizes.iconSmall(context),

                    color: MyColors.textSecondary,
                  ),
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
          borderSide: BorderSide(color: MyColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
          borderSide: BorderSide(color: MyColors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
          borderSide: BorderSide(color: MyColors.black),
        ),
      ),
    );
  }
}
