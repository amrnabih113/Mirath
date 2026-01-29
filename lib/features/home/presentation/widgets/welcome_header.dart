import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/profile_avatar.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    if (hour < 21) return '🌆';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: ResponsiveHelper.responsiveValue(context, 70),
      leadingWidth: ResponsiveHelper.responsiveValue(context, 70),
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
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: ResponsiveHelper.responsiveValue(
                  context,
                  MySizes.spaceMd(context),
                ),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedNotification01,
                size: MySizes.iconMedium(context),
              ),
            ),
            Positioned(
              right: ResponsiveHelper.responsiveValue(context, 12),
              top: ResponsiveHelper.responsiveValue(context, -2),
              child: Container(
                width: ResponsiveHelper.responsiveValue(context, 8),
                height: ResponsiveHelper.responsiveValue(context, 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: ResponsiveHelper.responsiveValue(context, 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: ResponsiveHelper.responsiveValue(context, 4),
                      spreadRadius: ResponsiveHelper.responsiveValue(
                        context,
                        1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
      titleSpacing: 0,
      title: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getGreeting(),
                style: context.bodyMedium.copyWith(
                  fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 0.3,
                  height: 1.2,
                  color: MyColors.primaryShade700,
                ),
              ),
              SizedBox(width: ResponsiveHelper.responsiveValue(context, 4)),
              Text(
                _getGreetingEmoji(),
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveValue(context, 14),
                  height: 1.2,
                ),
              ),
            ],
          ),
          Text(
            'John Doe',
            style: context.bodyMedium.copyWith(
              fontFamily: GoogleFonts.sourceSerif4().fontFamily,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: MyColors.primaryShade900,
            ),
          ),
        ],
      ),
    );
  }
}
