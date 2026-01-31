import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/community_cubit.dart';
import '../cubit/community_state.dart';
import '../widgets/discussion_card.dart';
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
            return const Center(child: Text('No discussions available'));
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
              if (index >= discussions.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      color:MyColors.primaryColor,
                    ),
                  ),
                );
              }

              return DiscussionCard(
                discussion: discussions[index],
                onTap: () {
                  context.push(
                    '/disscussion-details',
                    extra: discussions[index],
                  );
                },
              );
            },
            itemCount: discussions.length + (state.isLoadingMore ? 1 : 0),
          );
        }

        if (state is CommunityError) {
          return Center(child: Text(state.message));
        }

        return const Center(child: Text('Start browsing discussions'));
      },
    );
  }
}
