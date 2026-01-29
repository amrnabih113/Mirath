import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import 'category_item.dart';

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList({
    this.selectedCategory,
    super.key,
    this.categories = const [
      'Science',
      'Technology',
      'Engineering',
      'Mathematics',
      'Arts',
      'History',
      'Literature',
      'Philosophy',
      'Economics',
      'Psychology',
    ],
    this.onCategoryChanged,
  });
  final List<String> categories;
  final String? selectedCategory;
  final Function(String)? onCategoryChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.responsiveValue(context, 45),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategoryChanged?.call(categories[index]),
            child: CategoryItem(
              categoryName: categories[index],
              isSelected: selectedCategory == categories[index],
            ),
          );
        },
      ),
    );
  }
}
