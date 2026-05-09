import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/generated/l10n.dart';
import 'package:mirath/core/constants/route_names.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/community_cubit.dart';
import '../cubit/community_state.dart';
import '../widgets/discussion_card.dart';
import '../widgets/add_discussion_card.dart';
import '../widgets/discussion_shimmer_loading.dart';

class DiscussionTab extends StatefulWidget {
  const DiscussionTab({super.key});

  @override
  State<DiscussionTab> createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<DiscussionTab> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CommunityCubit>().getDiscussions();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context.read<CommunityCubit>().loadMoreDiscussions();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        if (state is CommunityLoading) {
          return const DiscussionShimmerLoading();
        }

        if (state is CommunityDiscussionsLoaded) {
          final discussions = state.discussions;

          if (discussions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.forum_outlined,
                    size: 80,
                    color: MyColors.primaryShade300,
                  ),
                  SizedBox(height: MySizes.spaceMd(context)),
                  Text(
                    'No discussions yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MyColors.primaryShade700,
                    ),
                  ),
                  SizedBox(height: MySizes.spaceXs(context)),
                  Text(
                    'Be the first to start a discussion!',
                    style: TextStyle(
                      fontSize: 14,
                      color: MyColors.primaryShade500,
                    ),
                  ),
                  SizedBox(height: MySizes.spaceLg(context)),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push(RouteNames.addDiscussion);
                    },
                    icon: const Icon(Icons.add_comment),
                    label: Text(S.of(context).start_discussion_button),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: MySizes.spaceLg(context),
                        vertical: MySizes.spaceSm(context),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: MySizes.spaceMd(context),
              bottom:
                  kBottomNavigationBarHeight +
                  MySizes.spaceMd(context) +
                  MediaQuery.of(context).padding.bottom,
            ),
            separatorBuilder: (context, index) =>
                SizedBox(height: MySizes.spaceMd(context)),
            itemBuilder: (context, index) {
              // Add discussion prompt card at the top
              if (index == 0) {
                return const AddDiscussionCard();
              }

              // Adjust index for actual discussions
              final discussionIndex = index - 1;

              if (discussionIndex >= discussions.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  ),
                );
              }

              return DiscussionCard(
                discussion: discussions[discussionIndex],
                onTap: () {
                  context.push(
                    RouteNames.discussionDetailsRoute(discussions[discussionIndex].id),
                    extra: discussions[discussionIndex],
                  );
                },
              );
            },
            itemCount: discussions.length + 1 + (state.isLoadingMore ? 1 : 0),
          );
        }

        if (state is CommunityError) {
          return Center(child: Text(state.message));
        }

        return Center(child: Text(S.of(context).empty_discussions_message));
      },
    );
  }
}
