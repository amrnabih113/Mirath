import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

//! deprecated use MySearchBar instead
class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, this.hint, this.hasIcon = true});
  final String? hint;
  final bool? hasIcon;

  @override
  Widget build(BuildContext context) {
    final searchcontroller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        right: MySizes.spaceMd(context),
        top: MySizes.spaceSm(context),
        bottom: MySizes.spaceMd(context),
      ),
      child: TextField(
        controller: searchcontroller,
        cursorColor: MyColors.primaryShade500,
        decoration: InputDecoration(
          hint: Text(hint ?? ''),
          contentPadding: EdgeInsets.symmetric(
            vertical: MySizes.spaceSm(context),
            horizontal: MySizes.spaceMd(context),
          ),
          filled: true,
          fillColor: MyColors.white,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: MySizes.spaceSm(context),
              right: MySizes.spaceXs(context),
            ),
            child: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
          ),
          suffixIcon: hasIcon!
              ? IconButton(
                  onPressed: () {},
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedCamera01),
                )
              : SizedBox.shrink(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MySizes.borderRadiusSm(context),
            ),
            borderSide: BorderSide(color: MyColors.primaryShade800, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MySizes.borderRadiusSm(context),
            ),
            borderSide: BorderSide(color: MyColors.primaryShade800, width: 1.5),
          ),
        ),
      ),
    );
  }
}
