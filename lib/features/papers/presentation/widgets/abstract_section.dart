import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/papers/presentation/widgets/my_text_icon.dart';

class AbstractSection extends StatelessWidget {
  const AbstractSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Abstract',
          style: context.headlineSmall.copyWith(
            color: MyColors.black,
            fontSize: 20,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: MySizes.spaceXs(context)),
        Text(
          'This manuscript reports on the commissioning of the Resonance ionization Spectroscopy Experiment (RISE) at the BECOLA facility at FRIB. The new instrument implements the collinear resonance ionization spectroscopy technique for sensitive measurements of isotope shifts and hyperfine structure of short-lived isotopes produced at FRIB. The existing BECOLA beamline was extended to integrate an electrostatic ion-beam bender and an ion detector at ultra-high vacuum. An injection-seeded Ti:Sapphire laser, as well as a multi-harmonic pulsed Nd:YAG laser were installed to perform resonant excitation and selective ionization. Commissioning tests were performed to demonstrate the capabilities of the new instrument by measuring the hyperfine structure of stable 27Al produced in an offline ion source. The RISE instrument is ready and operational for future studies of short-lived isotopes at FRIB.',
          style: context.bodyLarge.copyWith(
            color: MyColors.black,
            fontSize: 16,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MySizes.spaceMd(context)),
        Text(
          'Discussions',
          style: context.headlineSmall.copyWith(
            color: MyColors.black,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          children: [
            MyTextButton(
              title: 'View Discussions (12)',
              titleColor: MyColors.black,
              buttonColor: MyColors.primaryShade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            MyTextButton(
              title: 'Start a Discussion',
              icon: Icons.add,
              hasIcon: true,
              titleColor: MyColors.white,
              buttonColor: MyColors.primaryShade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  MySizes.borderRadiusSm(context),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Divider(color: MyColors.primaryShade800),
      ],
    );
  }
}
