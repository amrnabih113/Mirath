import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: MyColors.primaryShade500,
      readOnly: true,
      onTap: () {
        context.push(
          '/search',
          extra: {
            'items': ["Item 1", "Item 2", "Item 3"],
            'hintText': 'Search',
            'onItemTap': () => context.push('/home-search-results'),
          },
        );
      },

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
        hintText: 'Search papers, authors, keywords...',
        hintStyle: context.bodySmall,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
          borderSide: BorderSide(color: MyColors.primaryShade700, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
          borderSide: BorderSide(color: MyColors.primaryShade700, width: 1.5),
        ),
      ),
    );
  }
}
