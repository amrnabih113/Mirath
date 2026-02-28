import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';

class SearchScreenHeading extends StatelessWidget {
  final VoidCallback? onClearAll;

  const SearchScreenHeading({super.key, this.onClearAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent searches',
          style: context.bodyLarge.copyWith(
            color: MyColors.darkerGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: onClearAll,
          child: Text(
            'Clear All',
            style: context.titleSmall.copyWith(
              color: MyColors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
