import 'package:flutter/material.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';

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
              ? ResponsiveHelper.responsiveValue(context, 80)
              : ResponsiveHelper.responsiveValue(context, 40),
          height: ResponsiveHelper.responsiveValue(context, 7),
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
