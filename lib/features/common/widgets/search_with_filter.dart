import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/utils/my_sizes.dart';
import 'my_search_bar.dart';

class SearchWithFilter extends StatelessWidget {
  const SearchWithFilter({
    super.key,
    this.fileterOnTap,
    required this.searchController,
  });
  final void Function()? fileterOnTap;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MySearchBar(
            controller: searchController,
            hintText: 'Search',
            onTap: () => context.push(
              '/search',
              extra: {
                'items': ["Item 5", "Item 2", "Item 3"],
                'hintText': 'Search',
                'onItemTap': () => context.push('/community-search-results'),
              },
            ),
            readOnly: true,
          ),
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        IconButton(
          onPressed: fileterOnTap,
          icon: HugeIcon(
            size: MySizes.iconMedium(context),
            icon: HugeIcons.strokeRoundedFilterHorizontal,
          ),
        ),
      ],
    );
  }
}
