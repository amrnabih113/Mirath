import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final _Searchcontroller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(right: MySizes.spaceMd(context)),
      child: TextField(
        controller: _Searchcontroller,
        cursorColor: MyColors.primaryShade500,
        decoration: InputDecoration(
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
          suffixIcon: IconButton(
            onPressed: () {},
            icon: HugeIcon(icon: HugeIcons.strokeRoundedCamera01),
          ),
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
