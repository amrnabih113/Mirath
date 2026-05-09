import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../interests/domain/entities/interest.dart';
import 'category_item.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({
    this.interests = const [],
    this.selectedInterest,
    this.onInterestChanged,
    this.maxItems,
  });

  final List<Interest> interests;
  final String? selectedInterest;
  final void Function(String interestName)? onInterestChanged;
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    final displayItems = maxItems != null
        ? interests.take(maxItems!).toList()
        : interests;

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

          final interest = displayItems[index - 1];
          return GestureDetector(
            onTap: () => onInterestChanged?.call(interest.name),
            child: CategoryItem(
              categoryName: interest.name,
              isSelected: selectedInterest == interest.name,
            ),
          );
        },
      ),
    );
  }
}
