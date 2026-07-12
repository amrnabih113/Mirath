import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/helpers/responsive_helper.dart';
import '../../../core/utils/my_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size,
    this.imageUrl,
    this.borderWidth,
    this.borderColor,
  });
  final double? size;
  final String? imageUrl;
  final double? borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final responsiveSize =
        size ??
        ResponsiveHelper.responsiveValue(
          context,
          ResponsiveHelper.deviceTypeFromContext(context) != DeviceType.phone
              ? 35
              : 40,
        );
    final effectiveBorderWidth = borderWidth ?? 0;
    final contentSize = responsiveSize - (effectiveBorderWidth * 2);

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: effectiveBorderWidth > 0
            ? Border.all(
                color: borderColor ?? MyColors.primaryShade500,
                width: effectiveBorderWidth,
              )
            : null,
      ),
      child: CircleAvatar(
        radius: contentSize / 2,
        backgroundColor: Colors.transparent,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImageProvider(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? SvgPicture.asset(
                'assets/images/Profile picture.svg',
                fit: BoxFit.cover,
                height: contentSize,
                width: contentSize,
              )
            : null,
      ),
    );
  }
}
