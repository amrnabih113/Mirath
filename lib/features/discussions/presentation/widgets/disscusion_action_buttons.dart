import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_formaters.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/discussion.dart';
import '../cubit/community_cubit.dart';
import 'interaction_button.dart';

class DisscusionActionButtons extends StatelessWidget {
  final Discussion discussion;
  final void Function(String voteType)? onVote;

  const DisscusionActionButtons({
    super.key,
    required this.discussion,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          discussion.createdAt.day == DateTime.now().day
              ? MyFormaters.relativeTime(discussion.createdAt)
              : MyFormaters.formatDateTimeHours(discussion.createdAt),
          style: context.bodySmall.copyWith(color: MyColors.textSecondary),
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        Row(
          children: [
            Spacer(),
            InteractionButton(
              icon: HugeIcons.strokeRoundedArrowUp01,
              count: discussion.upvoteCount,
              isVoted: discussion.hasVoted && discussion.userVoteType == 'UP',
              voteType: 'UP',
              onTap: () {
                if (onVote != null) {
                  onVote!('UP');
                } else {
                  context.read<CommunityCubit>().voteOnDiscussion(
                    discussionId: discussion.id,
                    voteType: 'UP',
                  );
                }
              },
            ),
            SizedBox(width: MySizes.spaceSm(context)),
            InteractionButton(
              icon: HugeIcons.strokeRoundedArrowDown01,
              count: discussion.downvoteCount,
              isVoted: discussion.hasVoted && discussion.userVoteType == 'DOWN',
              voteType: 'DOWN',
              onTap: () {
                if (onVote != null) {
                  onVote!('DOWN');
                } else {
                  context.read<CommunityCubit>().voteOnDiscussion(
                    discussionId: discussion.id,
                    voteType: 'DOWN',
                  );
                }
              },
            ),
            SizedBox(width: MySizes.spaceSm(context)),
            InteractionButton(
              onTap: () => context.push(
                RouteNames.discussionDetailsRoute(discussion.id),
                extra: discussion,
              ),
              icon: HugeIcons.strokeRoundedComment01,
              count: discussion.commentCount,
            ),
            SizedBox(width: MySizes.spaceSm(context)),
            IconButton(
              onPressed: () {
                // Share discussion link
                // final discussionLink =
                //     '${MyConstants.baseUrl}/discussions/${discussion.id}';
              },
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedShare08,
                size: MySizes.iconMedium(context),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}
