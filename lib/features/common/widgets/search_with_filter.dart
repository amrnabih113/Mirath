import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/utils/my_sizes.dart';
import 'my_search_bar.dart';

class SearchWithFilter extends StatelessWidget {
  const SearchWithFilter({super.key, this.onTap,required this.searchController});
  final void Function()? onTap;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MySearchBar(controller: searchController, hintText: 'Search'),
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        IconButton(
          onPressed: onTap,
          icon: HugeIcon(
            size: MySizes.iconMedium(context),
            icon: HugeIcons.strokeRoundedFilterHorizontal,
          ),
        ),
      ],
    );
  }
}
