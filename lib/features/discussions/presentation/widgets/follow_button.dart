import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class FollowButton extends StatelessWidget {
  final String userId;
  final bool isFollowed;
  final bool isLoading;
  final VoidCallback onFollowTap;
  final VoidCallback onUnfollowTap;

  const FollowButton({
    super.key,
    required this.userId,
    required this.isFollowed,
    
    required this.isLoading,
    required this.onFollowTap,
    required this.onUnfollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : (isFollowed ? onUnfollowTap : onFollowTap),
      child: isLoading
          ? SizedBox(
              width: MySizes.iconSmall(context) * 1.2,
              height: MySizes.iconSmall(context) * 1.2,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  MyColors.primaryShade700,
                ),
              ),
            )
          : Row(
              children: [
                HugeIcon(
                  icon: isFollowed
                      ? HugeIcons.strokeRoundedCheckmarkBadge01
                      : HugeIcons.strokeRoundedAdd01,
                  size: MySizes.iconSmall(context) * 0.8,
                  color: MyColors.primaryShade700,
                ),
                SizedBox(width: MySizes.spaceXs(context) * 0.5),
                Text(
                  isFollowed ? 'Following' : 'Follow',
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryShade700,
                  ),
                ),
              ],
            ),
    );
  }
}
