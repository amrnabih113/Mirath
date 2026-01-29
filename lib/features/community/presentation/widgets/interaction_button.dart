import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class InteractionButton extends StatelessWidget {
  final dynamic icon;
  final int count;
  const InteractionButton({super.key, required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            size: MySizes.iconMedium(context),
            color: MyColors.textSecondary,
          ),
          SizedBox(width: MySizes.spaceXs(context) * 0.5),
          Text(
            count.toString(),
            style: context.bodySmall.copyWith(
              color: MyColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
