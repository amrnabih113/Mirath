import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import 'category_item.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({
    super.key,
    this.categories = const [],
    this.selectedInterest,
    this.onInterestChanged,
    this.maxItems,
    this.showAllTab = true, // ✅ NEW
  });

  final List<String> categories;
  final String? selectedInterest;
  final void Function(String interestName)? onInterestChanged;
  final int? maxItems;

  /// ✅ NEW FLAG
  final bool showAllTab;

  @override
  Widget build(BuildContext context) {
    final List<String> ordered = List<String>.from(categories);

    if (selectedInterest != null &&
        selectedInterest!.isNotEmpty &&
        ordered.contains(selectedInterest)) {
      ordered.remove(selectedInterest);
      ordered.insert(0, selectedInterest!);
    }

    final displayItems = maxItems != null
        ? ordered.take(maxItems!).toList()
        : ordered;

    final itemCount =
        displayItems.length + (showAllTab ? 1 : 0);

    return SizedBox(
      height: ResponsiveHelper.responsiveValue(context, 45),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          /// ✅ ALL TAB (OPTIONAL)
          if (showAllTab && index == 0) {
            return GestureDetector(
              onTap: () => onInterestChanged?.call(''),
              child: CategoryItem(
                categoryName: 'All',
                isSelected: selectedInterest == null ||
                    selectedInterest == '',
              ),
            );
          }

          final categoryName = displayItems[
              showAllTab ? index - 1 : index];

          return GestureDetector(
            onTap: () =>
                onInterestChanged?.call(categoryName),
            child: CategoryItem(
              categoryName: categoryName,
              isSelected:
                  selectedInterest == categoryName,
            ),
          );
        },
      ),
    );
  }
}