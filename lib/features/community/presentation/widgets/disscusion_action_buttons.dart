import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_formaters.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/community/domain/entities/discussion.dart';
import 'package:mirath/features/community/presentation/cubit/community_cubit.dart';
import 'package:mirath/features/community/presentation/widgets/interaction_button.dart';

class DisscusionActionButtons extends StatelessWidget {
  final Discussion discussion;

  const DisscusionActionButtons({super.key, required this.discussion});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          MyFormaters.relativeTime(discussion.createdAt),
          style: context.bodySmall.copyWith(color: MyColors.textSecondary),
        ),
        const Spacer(),
        InteractionButton(
          icon: HugeIcons.strokeRoundedArrowUp01,
          count: discussion.voteScore > 0 ? discussion.voteScore : 0,
          isVoted: discussion.hasVoted && discussion.userVoteType == 'UP',
          voteType: 'UP',
          onTap: () {
            context.read<CommunityCubit>().voteOnDiscussion(
              discussionId: discussion.id,
              voteType: 'UP',
            );
          },
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        InteractionButton(
          icon: HugeIcons.strokeRoundedArrowDown01,
          count: discussion.voteScore < 0 ? -discussion.voteScore : 0,
          isVoted: discussion.hasVoted && discussion.userVoteType == 'DOWN',
          voteType: 'DOWN',
          onTap: () {
            context.read<CommunityCubit>().voteOnDiscussion(
              discussionId: discussion.id,
              voteType: 'DOWN',
            );
          },
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        InteractionButton(
          icon: HugeIcons.strokeRoundedComment01,
          count: discussion.commentCount,
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        IconButton(
          onPressed: () {},
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedShare08,
            size: MySizes.iconMedium(context),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
