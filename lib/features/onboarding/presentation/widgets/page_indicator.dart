import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index
              ? MySizes.spaceXl(context) * 2.3
              : MySizes.spaceXl(context),
          height: MySizes.spaceXs(context),
          decoration: BoxDecoration(
            color: currentPage == index
                ? MyColors.primaryShade700
                : MyColors.primaryShade700.withAlpha(60),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
