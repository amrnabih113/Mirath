import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

/// Paper Shimmer Loading Widget
/// Displays skeleton loading animation for paper cards
/// Matches the design and behavior of DiscussionShimmerLoading
class PaperShimmerLoading extends StatelessWidget {
  final int itemCount;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const PaperShimmerLoading({
    super.key,
    this.itemCount = 5,
    this.padding,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          padding ??
          EdgeInsets.only(
            top: MySizes.spaceMd(context),
            bottom:
                kBottomNavigationBarHeight +
                MySizes.spaceMd(context) +
                MediaQuery.of(context).padding.bottom,
          ),
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      separatorBuilder: (context, index) =>
          SizedBox(height: MySizes.spaceMd(context)),
      itemCount: itemCount,
      itemBuilder: (context, index) => const _PaperCardShimmer(),
    );
  }
}

/// Individual Paper Card Shimmer
class _PaperCardShimmer extends StatelessWidget {
  const _PaperCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingMd(context),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 18),
        ),
        border: Border.all(
          color: MyColors.primaryShade200.withValues(alpha: 0.4),
          width: ResponsiveHelper.responsiveValue(context, 1.5),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: MyColors.primaryShade100,
        highlightColor: MyColors.primaryShade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            Container(
              width: double.infinity,
              height: ResponsiveHelper.responsiveValue(context, 24),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),

            // Subtitle shimmer
            Container(
              width: double.infinity * 0.8,
              height: ResponsiveHelper.responsiveValue(context, 16),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceMd(context)),

            // Author header with avatar
            Row(
              children: [
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 36),
                  height: ResponsiveHelper.responsiveValue(context, 36),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: MySizes.spaceSm(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: ResponsiveHelper.responsiveValue(context, 14),
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: MySizes.spaceXs(context) * 0.5),
                      Container(
                        width: 100,
                        height: ResponsiveHelper.responsiveValue(context, 12),
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceMd(context)),

            // Stats row
            Row(
              children: [
                Container(
                  width: 80,
                  height: ResponsiveHelper.responsiveValue(context, 14),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: MySizes.spaceMd(context)),
                Container(
                  width: 80,
                  height: ResponsiveHelper.responsiveValue(context, 14),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: ResponsiveHelper.responsiveValue(context, 14),
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
