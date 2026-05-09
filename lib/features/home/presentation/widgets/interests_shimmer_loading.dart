import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

class InterestsShimmerLoading extends StatelessWidget {
  const InterestsShimmerLoading({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.responsiveValue(context, 45),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(width: MySizes.spaceSm(context)),
        itemBuilder: (_, index) => _InterestChipShimmer(index: index),
      ),
    );
  }
}

class _InterestChipShimmer extends StatelessWidget {
  const _InterestChipShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final widths = <double>[64, 78, 88, 70, 96, 74];
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Container(
        width: widths[index % widths.length],
        height: ResponsiveHelper.responsiveValue(context, 36),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        ),
      ),
    );
  }
}
