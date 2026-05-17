import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

class DiscussionDetailsShimmerLoading extends StatelessWidget {
  const DiscussionDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: null,
        // preserve toolbar sizing
        height: ResponsiveHelper.responsiveValue(context, 50),
        leading: Shimmer.fromColors(
          baseColor: MyColors.primaryShade100,
          highlightColor: MyColors.primaryShade50,
          child: Container(
            margin: EdgeInsets.all(MySizes.spaceXs(context)),
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
            child: Shimmer.fromColors(
              baseColor: MyColors.primaryShade100,
              highlightColor: MyColors.primaryShade50,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: MyBody(
        padding: MySizes.paddingMd(context),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // User header shimmer
              SliverToBoxAdapter(child: _buildUserHeaderShimmer(context)),
              SliverToBoxAdapter(
                child: SizedBox(height: MySizes.spaceMd(context)),
              ),
              // Title shimmer
              SliverToBoxAdapter(child: _buildTitleShimmer(context)),
              SliverToBoxAdapter(
                child: SizedBox(height: MySizes.spaceMd(context)),
              ),
              // Content shimmer
              SliverToBoxAdapter(child: _buildContentShimmer(context)),
              SliverToBoxAdapter(
                child: SizedBox(height: MySizes.spaceMd(context)),
              ),
              // Tags shimmer
              SliverToBoxAdapter(child: _buildTagsShimmer(context)),
              SliverToBoxAdapter(
                child: SizedBox(height: MySizes.spaceMd(context)),
              ),
              // Action buttons shimmer
              SliverToBoxAdapter(child: _buildActionButtonsShimmer(context)),
              SliverToBoxAdapter(
                child: SizedBox(height: MySizes.spaceLg(context)),
              ),
              // Comments section title
              SliverToBoxAdapter(
                child: Shimmer.fromColors(
                  baseColor: MyColors.primaryShade100,
                  highlightColor: MyColors.primaryShade50,
                  child: Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: MySizes.spaceMd(context)),
              ),
              // Comments shimmer
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCommentShimmer(context),
                  childCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeaderShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
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
                // Username
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: MySizes.spaceXs(context) * 0.5),
                // Time and role
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: MySizes.spaceXs(context)),
          Container(
            width: double.infinity * 0.7,
            height: 20,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            width: 100,
            height: 28,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          SizedBox(width: MySizes.spaceXs(context)),
          Container(
            width: 100,
            height: 28,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Row(
        children: [
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
          SizedBox(width: MySizes.spaceSm(context)),
          Container(
            width: 40,
            height: 32,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const Spacer(),
          Container(
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentShimmer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MySizes.spaceMd(context)),
      child: Shimmer.fromColors(
        baseColor: MyColors.primaryShade100,
        highlightColor: MyColors.primaryShade50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: ResponsiveHelper.responsiveValue(context, 32),
              height: ResponsiveHelper.responsiveValue(context, 32),
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
                  // Username and time
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context)),
                  // Comment text
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context) * 0.5),
                  Container(
                    width: double.infinity * 0.7,
                    height: 16,
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
      ),
    );
  }
}

class CommentShimmerLoading extends StatelessWidget {
  const CommentShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MySizes.spaceMd(context)),
      child: Shimmer.fromColors(
        baseColor: MyColors.primaryShade100,
        highlightColor: MyColors.primaryShade50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: ResponsiveHelper.responsiveValue(context, 32),
              height: ResponsiveHelper.responsiveValue(context, 32),
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
                  // Username and time
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context)),
                  // Comment text
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context) * 0.5),
                  Container(
                    width: double.infinity * 0.7,
                    height: 16,
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
      ),
    );
  }
}
