import 'package:flutter/material.dart';
import '../../../../../core/utils/my_colors.dart';
import '../../../../../core/utils/my_extenstions.dart';
import '../../../../../core/utils/my_sizes.dart';

class VoteButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isVoted;
  final String? voteType; // 'UP' or 'DOWN'

  const VoteButton({
    super.key,
    required this.icon,
    required this.count,
    this.isVoted = false,
    this.voteType,
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

    return Row(
      children: [
        Icon(icon, size: MySizes.iconSmall(context), color: buttonColor),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: context.bodySmall.copyWith(color: buttonColor),
        ),
      ],
    );
  }
}
