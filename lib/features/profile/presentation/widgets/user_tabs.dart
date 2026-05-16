import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_cubit.dart';
import 'package:mirath/features/discussions/presentation/cubit/community_state.dart';
import 'package:mirath/features/discussions/presentation/widgets/discussion_card.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_state.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_card.dart';
import 'package:mirath/generated/l10n.dart';
import 'package:mirath/injection/injection_container.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/ui/widgets/state_views.dart';

class UserTabs extends StatelessWidget {
  const UserTabs({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: TabBarView(
        children: [
          BlocProvider(
            create: (_) => sl<ReadingListCubit>()..getOwnerReadingLists(userId),
            child: BlocBuilder<ReadingListCubit, ReadingListState>(
              builder: (context, state) {
                if (state is ReadingListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ReadingListError) {
                  final offline =
                      !NetworkManager.instance.currentConnectionStatus;
                  return offline
                      ? OfflineStateView(
                          title: 'Offline',
                          message: state.message,
                          actionLabel: 'Retry',
                          onAction: () => context
                              .read<ReadingListCubit>()
                              .getOwnerReadingLists(userId, forceRefresh: true),
                        )
                      : ErrorStateView(
                          title: 'Error',
                          message: state.message,
                          actionLabel: 'Retry',
                          onAction: () => context
                              .read<ReadingListCubit>()
                              .getOwnerReadingLists(userId, forceRefresh: true),
                        );
                }

                if (state is ReadingListsLoaded) {
                  if (state.readingLists.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<ReadingListCubit>()
                          .getOwnerReadingLists(userId, forceRefresh: true),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Center(
                              child: Text(S.of(context).no_results_found),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<ReadingListCubit>()
                        .getOwnerReadingLists(userId, forceRefresh: true),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.readingLists.length,
                      itemBuilder: (context, index) => ReadingListCard(
                        readingList: state.readingLists[index],
                        onTap: () {
                          context.push(
                            RouteNames.readingListDetailsRoute(
                              state.readingLists[index].id,
                            ),
                            extra: state.readingLists[index],
                          );
                        },
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          BlocProvider(
            create: (_) =>
                sl<CommunityCubit>()..getDiscussions(authorId: userId),
            child: BlocBuilder<CommunityCubit, CommunityState>(
              builder: (context, state) {
                if (state is CommunityLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CommunityError) {
                  final offline =
                      !NetworkManager.instance.currentConnectionStatus;
                  return offline
                      ? OfflineStateView(
                          title: 'Offline',
                          message: state.message,
                          actionLabel: 'Retry',
                          onAction: () =>
                              context.read<CommunityCubit>().getDiscussions(
                                authorId: userId,
                                forceRefresh: true,
                              ),
                        )
                      : ErrorStateView(
                          title: 'Error',
                          message: state.message,
                          actionLabel: 'Retry',
                          onAction: () =>
                              context.read<CommunityCubit>().getDiscussions(
                                authorId: userId,
                                forceRefresh: true,
                              ),
                        );
                }

                if (state is CommunityDiscussionsLoaded) {
                  if (state.discussions.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<CommunityCubit>()
                          .getDiscussions(authorId: userId, forceRefresh: true),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Center(
                              child: Text(S.of(context).no_results_found),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<CommunityCubit>()
                        .getDiscussions(authorId: userId, forceRefresh: true),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.discussions.length,
                      itemBuilder: (context, index) {
                        final discussion = state.discussions[index];
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
