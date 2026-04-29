import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class ReaderSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final int searchCurrent;
  final int searchTotal;
  final VoidCallback onClose;
  final VoidCallback onSearch;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const ReaderSearchBar({
    super.key,
    required this.controller,
    required this.searchCurrent,
    required this.searchTotal,
    required this.onClose,
    required this.onSearch,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: ResponsiveHelper.responsiveValue(context, 3),
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.responsiveValue(context, 18),
      ),
      child: Container(
        padding: MySizes.paddingMd(context),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 18),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: MySizes.spaceSm(context)),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search in paper...',
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onSubmitted: (_) => onSearch(),
              ),
            ),
            if (searchTotal > 0)
              Text(
                '$searchCurrent of $searchTotal',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (searchTotal > 0) SizedBox(width: MySizes.spaceSm(context)),
            IconButton(
              onPressed: searchTotal > 0 ? onPrevious : null,
              icon: const Icon(Icons.keyboard_arrow_up),
              iconSize: MySizes.iconMedium(context),
            ),
            IconButton(
              onPressed: searchTotal > 0 ? onNext : null,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: MySizes.iconMedium(context),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              iconSize: MySizes.iconMedium(context),
            ),
          ],
        ),
      ),
    );
  }
}
