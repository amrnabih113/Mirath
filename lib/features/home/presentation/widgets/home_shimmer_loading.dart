import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

// Shimmer for paper cards list
class PaperListShimmer extends StatelessWidget {
  final int itemCount;

  const PaperListShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: MySizes.spaceMd(context)),
      itemBuilder: (_, __) => const PaperCardShimmer(),
    );
  }
}

// Individual paper card shimmer
class PaperCardShimmer extends StatelessWidget {
  const PaperCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.white,
      child: Container(
        padding: MySizes.paddingMd(context),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
          border: Border.all(color: MyColors.primaryShade50, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceXs(context)),
            Container(
              width: 200,
              height: 18,
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),

            // Author & date shimmer
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: MyColors.white),
                SizedBox(width: MySizes.spaceXs(context)),
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceXs(context)),

            // Stats shimmer
            Row(
              children: [
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: MySizes.spaceMd(context)),
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
