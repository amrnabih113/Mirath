import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../discussions/presentation/cubit/community_cubit.dart';
import '../../../discussions/presentation/cubit/community_state.dart';
import '../../../discussions/presentation/widgets/discussion_card.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

class PaperDiscussionsScreen extends StatefulWidget {
  final PaperEntity? paper;
  final String? paperId;

  const PaperDiscussionsScreen({super.key, this.paper, this.paperId});

  @override
  State<PaperDiscussionsScreen> createState() => _PaperDiscussionsScreenState();
}

class _PaperDiscussionsScreenState extends State<PaperDiscussionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityCubit>().getDiscussions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        height: ResponsiveHelper.responsiveValue(context, 50),
        leading: MyBackIcon(),
        title: Text(
          S.of(context).discussions_label,
          style: context.titleMedium,
        ),
      ),
      body: MyBody(
        child: BlocBuilder<CommunityCubit, CommunityState>(
          builder: (context, state) {
            if (state is CommunityLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CommunityError) {
              return Center(
                child: Text(state.message, style: context.bodyMedium),
              );
            }

            if (state is CommunityDiscussionsLoaded) {
              final targetId = widget.paper?.id ?? widget.paperId;
              final discussions = state.discussions
                  .where((d) => d.papers.any((p) => p.id == targetId))
                  .toList();

              if (discussions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No discussions yet', style: context.titleMedium),
                      SizedBox(height: MySizes.spaceSm(context)),
                      Text(
                        'Be the first to start a discussion about this paper',
                        style: context.bodyMedium.copyWith(
                          color: MyColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: MySizes.spaceMd(context)),
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            RouteNames.addDiscussion,
                            extra: widget.paper ?? widget.paperId,
                          );
                        },
                        child: Text(S.of(context).start_discussion_button),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: MySizes.paddingMd(context),
                child: ListView.separated(
                  itemCount: discussions.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(height: MySizes.spaceMd(context)),
                  itemBuilder: (context, index) {
                    final discussion = discussions[index];
                    return DiscussionCard(
                      discussion: discussion,
                      onTap: () {
                        context.push(
                          RouteNames.discussionDetailsRoute(discussion.id),
                          extra: discussion,
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
