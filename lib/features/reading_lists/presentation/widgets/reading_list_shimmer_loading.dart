import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

class ReadingListShimmerLoading extends StatelessWidget {
  final int itemCount;

  const ReadingListShimmerLoading({super.key, this.itemCount = 4});

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
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const _ReadingListCardShimmer();
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: MySizes.spaceMd(context));
      },
    );
  }
}

class _ReadingListCardShimmer extends StatelessWidget {
  const _ReadingListCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Container(
        padding: MySizes.paddingMd(context),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 20),
          ),
          border: Border.all(
            color: MyColors.primaryShade400.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 120),
                  height: ResponsiveHelper.responsiveValue(context, 14),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.responsiveValue(context, 4),
                    ),
                  ),
                ),
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 28),
                  height: ResponsiveHelper.responsiveValue(context, 28),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.responsiveValue(context, 8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceXs(context) * 0.5),
            Container(
              width: double.infinity,
              height: ResponsiveHelper.responsiveValue(context, 20),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 4),
                ),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context) * 0.75),
            Container(
              width: ResponsiveHelper.responsiveValue(context, 180),
              height: ResponsiveHelper.responsiveValue(context, 12),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 4),
                ),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            Divider(
              color: MyColors.primaryShade300,
              thickness: 1,
              height: MySizes.spaceMd(context),
            ),
            Container(
              width: double.infinity,
              height: ResponsiveHelper.responsiveValue(context, 14),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 4),
                ),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            Row(
              children: [
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 80),
                  height: ResponsiveHelper.responsiveValue(context, 24),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.responsiveValue(context, 12),
                    ),
                  ),
                ),
                SizedBox(width: MySizes.spaceXs(context)),
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 60),
                  height: ResponsiveHelper.responsiveValue(context, 24),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.responsiveValue(context, 12),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: ResponsiveHelper.responsiveValue(context, 28),
                  height: ResponsiveHelper.responsiveValue(context, 28),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.responsiveValue(context, 8),
                    ),
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
