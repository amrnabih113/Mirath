import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/papers/presentation/widgets/my_text_icon.dart';

class PaperInfo extends StatelessWidget {
  const PaperInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commissioning the Resonance ionization Spectroscopy Experiment at FRIB',
          style: context.titleLarge.copyWith(
            color: MyColors.black,
            fontSize: 24,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Text(
          'A.J. Brinson, B.J. Rickey, J. M. Allmond, J. M. Allmond, A. Dockery... Show all authors',
          style: context.titleSmall.copyWith(
            color: MyColors.primaryShade900,
            fontSize: 16,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          children: [
            Text(
              'Preprint ',
              style: context.labelSmall.copyWith(
                color: MyColors.warning,
                fontSize: 12,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '. November 2025 .',
              style: context.labelSmall.copyWith(
                color: MyColors.black,
                fontSize: 12,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 4),
            Text(
              'Open Access',
              style: context.labelSmall.copyWith(
                color: MyColors.success,
                fontSize: 12,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Text(
          'ID: arXiv:2511.08881',
          style: context.labelSmall.copyWith(
            color: MyColors.black,
            fontSize: 12,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          children: [
            TagChip(label: 'Instrumentation and Detectors'),
            SizedBox(width: 4),
            TagChip(label: 'Nuclear Experiment'),
          ],
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextButton(
              title: 'Read',
              titleColor: MyColors.black,
              buttonColor: MyColors.primaryShade50,
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            MyTextButton(
              title: 'Save',
              titleColor: MyColors.white,
              buttonColor: MyColors.primaryShade800,
            ),
          ],
        ),
      ],
    );
  }
}
