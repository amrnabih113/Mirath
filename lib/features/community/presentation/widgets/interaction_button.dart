import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class InteractionButton extends StatelessWidget {
  final dynamic icon;
  final int count;
  final bool isVoted;
  final String? voteType; // 'UP' or 'DOWN'
  final VoidCallback? onTap;

  const InteractionButton({
    super.key,
    required this.icon,
    required this.count,
    this.isVoted = false,
    this.voteType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late final Color buttonColor;

    if (!isVoted) {
      buttonColor = MyColors.textSecondary;
    } else {
      // Different colors for UP vote (green) and DOWN vote (redish pink)
      if (voteType == 'UP') {
        buttonColor = MyColors.success; // Green color
      } else if (voteType == 'DOWN') {
        buttonColor = const Color(0xFFE94B8F); // Redish pink color
      } else {
        buttonColor = MyColors.primaryColor; // Default fallback
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            size: MySizes.iconMedium(context),
            color: buttonColor,
          ),
          SizedBox(width: MySizes.spaceXs(context) * 0.5),
          Text(
            count.toString(),
            style: context.bodySmall.copyWith(
              color: buttonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
