import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:shimmer/shimmer.dart';

class DiscussionShimmerLoading extends StatelessWidget {
  final int itemCount;

  const DiscussionShimmerLoading({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: MySizes.spaceMd(context),
        bottom:
            kBottomNavigationBarHeight +
            MySizes.spaceMd(context) +
            MediaQuery.of(context).padding.bottom,
      ),
      separatorBuilder: (context, index) =>
          SizedBox(height: MySizes.spaceMd(context)),
      itemCount: itemCount,
      itemBuilder: (context, index) => _DiscussionCardShimmer(),
    );
  }
}

class _DiscussionCardShimmer extends StatelessWidget {
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
            // User header
            Row(
              children: [
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 40),
                  height: ResponsiveHelper.responsiveValue(context, 40),
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
                        height: 16,
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: MySizes.spaceXs(context) * 0.5),
                      Container(
                        width: 180,
                        height: 14,
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
            // Title
            Container(
              width: double.infinity,
              height: 24,
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            // Content
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceXs(context)),
            Container(
              width: double.infinity * 0.8,
              height: 16,
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            // Tags
            Row(
              children: [
                Container(
                  width: 100,
                  height: 28,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                SizedBox(width: MySizes.spaceXs(context)),
                Container(
                  width: 80,
                  height: 28,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            // Action buttons
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
                const Spacer(),
                Container(
                  width: 40,
                  height: 32,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                SizedBox(width: MySizes.spaceSm(context)),
                Container(
                  width: 40,
                  height: 32,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(16),
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
