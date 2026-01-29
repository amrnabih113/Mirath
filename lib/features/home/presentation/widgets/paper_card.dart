import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class PaperCard extends StatefulWidget {
  const PaperCard({super.key, this.number});
  final int? number;

  @override
  State<PaperCard> createState() => _PaperCardState();
}

bool isSaved = false;

class _PaperCardState extends State<PaperCard> {
  @override
  Widget build(BuildContext context) {
    final isTopRanked = widget.number != null && widget.number! <= 3;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(context, 16)),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 16),
          ),
          // border: Border.all(
          //   color: MyColors.primaryShade500.withValues(alpha: 0.3),
          //   width: 1,
          // ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.06),
              blurRadius: ResponsiveHelper.responsiveValue(context, 16),
              offset: Offset(0, ResponsiveHelper.responsiveValue(context, 4)),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.03),
              blurRadius: ResponsiveHelper.responsiveValue(context, 8),
              offset: Offset(0, ResponsiveHelper.responsiveValue(context, 2)),
              spreadRadius: ResponsiveHelper.responsiveValue(context, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (widget.number != null) ...[
                      Text(
                        '${widget.number}.',
                        style: context.titleSmall.copyWith(
                          color: MyColors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (isTopRanked) ...[
                        SizedBox(
                          width: ResponsiveHelper.responsiveValue(context, 4),
                        ),
                        Text(
                          '🔥',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveValue(
                              context,
                              14,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                        width: ResponsiveHelper.responsiveValue(context, 6),
                      ),
                    ],
                    Text(
                      'J. Phys. Commun. • 2022',
                      style: context.bodySmall.copyWith(
                        color: MyColors.primaryShade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => setState(() => isSaved = !isSaved),
                  icon: Icon(
                    isSaved
                        ? HugeIconsSolid.bookmark02
                        : HugeIconsStroke.bookmark02,
                    color: MyColors.primaryShade700,
                    weight: 3,
                    size: ResponsiveHelper.responsiveValue(context, 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceXs(context) * 0.5),
            Text(
              'What does it take to solve the measurement problem?',
              style: context.titleMedium.copyWith(
                color: MyColors.primaryShade900,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w700,
                height: 1.3,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: MySizes.spaceXs(context)),
            Text(
              'Jonte R Hance and Sabine Hossenfelder',
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade700,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.responsiveValue(context, 13),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            Wrap(
              spacing: MySizes.spaceXs(context) / 2,
              runSpacing: MySizes.spaceXs(context),
              children: [
                _tag(context, 'Quantum Mechanics'),
                _tag(context, 'The Measurement Problem'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(context, 12),
        vertical: ResponsiveHelper.responsiveValue(context, 6),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryShade200.withValues(alpha: 0.4),
            MyColors.primaryShade300.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 8),
        ),
      ),
      child: Text(
        text,
        style: context.bodySmall.copyWith(
          fontSize: ResponsiveHelper.responsiveValue(context, 11.5),
          color: MyColors.primaryShade900,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
