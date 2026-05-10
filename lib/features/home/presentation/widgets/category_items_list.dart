import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import 'category_item.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({
    this.categories = const [],
    this.selectedInterest,
    this.onInterestChanged,
    this.maxItems,
  });

  final List<String> categories;
  final String? selectedInterest;
  final void Function(String interestName)? onInterestChanged;
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    // Move selected category to the beginning of the list (after "All")
    final List<String> ordered = List<String>.from(categories);
    if (selectedInterest != null &&
        selectedInterest != '' &&
        ordered.contains(selectedInterest)) {
      ordered.remove(selectedInterest);
      ordered.insert(0, selectedInterest!);
    }

    final displayItems = maxItems != null
        ? ordered.take(maxItems!).toList()
        : ordered;

    return SizedBox(
      height: ResponsiveHelper.responsiveValue(context, 45),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: displayItems.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          // First item is "All"
          if (index == 0) {
            return GestureDetector(
              onTap: () => onInterestChanged?.call(''),
              child: CategoryItem(
                categoryName: 'All',
                isSelected: selectedInterest == null || selectedInterest == '',
              ),
            );
          }

          final categoryName = displayItems[index - 1];
          return GestureDetector(
            onTap: () => onInterestChanged?.call(categoryName),
            child: CategoryItem(
              categoryName: categoryName,
              isSelected: selectedInterest == categoryName,
            ),
          );
        },
      ),
    );
  }
}
