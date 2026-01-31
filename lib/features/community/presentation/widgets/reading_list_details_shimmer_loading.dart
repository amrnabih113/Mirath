import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

class ReadingListDetailsShimmerLoading extends StatelessWidget {
  const ReadingListDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeaderShimmer(context)),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(child: _buildTitleShimmer(context)),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceSm(context)),
                      ),
                      SliverToBoxAdapter(
                        child: _buildDescriptionShimmer(context),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(child: _buildTagsShimmer(context)),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceLg(context)),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildPaperShimmer(context),
                          childCount: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Row(
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
                  height: 14,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: MySizes.spaceXs(context) * 0.5),
                Container(
                  width: 180,
                  height: 12,
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
    );
  }

  Widget _buildTitleShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Container(
        width: double.infinity,
        height: 22,
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildDescriptionShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: MySizes.spaceXs(context)),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Row(
        children: [
          Container(
            width: 90,
            height: ResponsiveHelper.responsiveValue(context, 24),
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(width: MySizes.spaceXs(context)),
          Container(
            width: 70,
            height: ResponsiveHelper.responsiveValue(context, 24),
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaperShimmer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MySizes.spaceMd(context)),
      child: Shimmer.fromColors(
        baseColor: MyColors.primaryShade100,
        highlightColor: MyColors.primaryShade50,
        child: Container(
          padding: MySizes.paddingMd(context),
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.responsiveValue(context, 16),
            ),
            border: Border.all(
              color: MyColors.primaryShade500.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                width: 160,
                height: 12,
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: MySizes.spaceSm(context)),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: ResponsiveHelper.responsiveValue(context, 24),
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(width: MySizes.spaceXs(context)),
                  Container(
                    width: 60,
                    height: ResponsiveHelper.responsiveValue(context, 24),
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
