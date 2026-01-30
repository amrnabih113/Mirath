import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            size: MySizes.iconSmall(context) * 0.8,
            color: MyColors.primaryShade700,
          ),
          SizedBox(width: MySizes.spaceXs(context) * 0.5),
          Text(
            'Follow',
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
