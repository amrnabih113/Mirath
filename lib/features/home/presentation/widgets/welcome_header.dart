import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/profile_avatar.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: ResponsiveHelper.responsiveValue(context, 70),
      leadingWidth: ResponsiveHelper.responsiveValue(context, 60),
      leading: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveHelper.responsiveValue(context, 8),
          top: ResponsiveHelper.responsiveValue(context, 8),
          bottom: ResponsiveHelper.responsiveValue(context, 8),
          right: 0,
        ),
        child: ProfileAvatar(),
      ),
      actions: [
        Padding(
          padding: MySizes.paddingSm(context),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            color: Colors.black,
            size: MySizes.iconSmall(context),
          ),
        ),
      ],
      titleSpacing: 0,
      title: Column(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning,',
            style: context.bodyMedium.copyWith(
              fontFamily: GoogleFonts.sourceSerif4().fontFamily,
              fontWeight: FontWeight.w400,
              wordSpacing: 0.3,
              height: 0.8,
            ),
          ),
          Text(
            'John Doe',
            style: context.bodyMedium.copyWith(
              fontFamily: GoogleFonts.sourceSerif4().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
