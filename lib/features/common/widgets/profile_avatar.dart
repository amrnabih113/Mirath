import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/helpers/responsive_helper.dart';
import '../../../core/utils/my_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 40});
  final double size;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: MyColors.light,
      child: SvgPicture.asset(
        'assets/images/Profile picture.svg',
        fit: BoxFit.cover,
        height: ResponsiveHelper.responsiveValue(context, size),
        width: ResponsiveHelper.responsiveValue(context, size),
      ),
    );
  }
}
