import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

/// Paper Reading Shimmer Loading Widget
/// Displays skeleton loading animation that mimics the paper content layout
class PaperReadingShimmerLoading extends StatelessWidget {
  const PaperReadingShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: MySizes.paddingMd(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Paper title shimmer
            Shimmer.fromColors(
              baseColor: MyColors.primaryShade100,
              highlightColor: MyColors.primaryShade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: ResponsiveHelper.responsiveValue(context, 28),
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(
                        MySizes.borderRadiusSm(context),
                      ),
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context)),
                  Container(
                    width: double.infinity * 0.7,
                    height: ResponsiveHelper.responsiveValue(context, 28),
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(
                        MySizes.borderRadiusSm(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MySizes.spaceLg(context)),

            // Section header shimmer
            _buildSectionShimmer(context),
            SizedBox(height: MySizes.spaceMd(context)),

            // Paragraph shimmer
            _buildParagraphShimmer(context, lines: 4),
            SizedBox(height: MySizes.spaceLg(context)),

            // Section header shimmer
            _buildSectionShimmer(context),
            SizedBox(height: MySizes.spaceMd(context)),

            // Paragraph shimmer
            _buildParagraphShimmer(context, lines: 3),
            SizedBox(height: MySizes.spaceMd(context)),

            // Sub-section header shimmer
            _buildSubSectionShimmer(context),
            SizedBox(height: MySizes.spaceSm(context)),

            // Paragraph shimmer
            _buildParagraphShimmer(context, lines: 5),
            SizedBox(height: MySizes.spaceLg(context)),

            // Section header shimmer
            _buildSectionShimmer(context),
            SizedBox(height: MySizes.spaceMd(context)),

            // Paragraph shimmer
            _buildParagraphShimmer(context, lines: 4),
            SizedBox(height: MySizes.spaceMd(context)),

            // Paragraph shimmer
            _buildParagraphShimmer(context, lines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Container(
        width: ResponsiveHelper.responsiveValue(context, 200),
        height: ResponsiveHelper.responsiveValue(context, 24),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
        ),
      ),
    );
  }

  Widget _buildSubSectionShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Container(
        width: ResponsiveHelper.responsiveValue(context, 160),
        height: ResponsiveHelper.responsiveValue(context, 20),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
        ),
      ),
    );
  }

  Widget _buildParagraphShimmer(BuildContext context, {required int lines}) {
    return Shimmer.fromColors(
      baseColor: MyColors.primaryShade100,
      highlightColor: MyColors.primaryShade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          lines,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: MySizes.spaceXs(context)),
            child: Container(
              width: index == lines - 1
                  ? double.infinity *
                        0.6 // Last line shorter
                  : double.infinity,
              height: ResponsiveHelper.responsiveValue(context, 16),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(
                  MySizes.borderRadiusSm(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
