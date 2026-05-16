import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryShade900.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        cursorColor: MyColors.primaryShade500,

        readOnly: true,
        onTap: () {
          context.push(RouteNames.search);
        },

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: MySizes.spaceSm(context),
            horizontal: MySizes.spaceMd(context),
          ),

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
          hintText: S.of(context).search_papers_authors_keywords,
          hintStyle: context.bodySmall,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MySizes.borderRadiusMd(context),
            ),
            borderSide: BorderSide(color: MyColors.primaryShade50, width: 1),
          ),
          border: OutlineInputBorder(
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
        ),
      ),
    );
  }
}
