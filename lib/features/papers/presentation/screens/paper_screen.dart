import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/papers/presentation/widgets/expainsion_tile_widget.dart';
import 'package:mirath/features/papers/presentation/widgets/my_text_icon.dart';

class PaperScreen extends StatelessWidget {
  const PaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 30),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leading: MyBackIcon(),
                  actions: [
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedMoreHorizontalCircle01,
                        size: MySizes.iconLarge(context),
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: MySizes.spaceMd(context)),
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
              SizedBox(height: MySizes.spaceMd(context)),
              ExpainsionTileWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
