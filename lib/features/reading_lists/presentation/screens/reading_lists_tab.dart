import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';

import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../cubit/reading_list_cubit.dart';
import '../cubit/reading_list_state.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/ui/widgets/state_views.dart';
import '../widgets/reading_list_card.dart';
import '../widgets/reading_list_shimmer_loading.dart';

class ReadingListsTab extends StatelessWidget {
  const ReadingListsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReadingListCubit>()..getAllReadingLists(),
      child: BlocBuilder<ReadingListCubit, ReadingListState>(
        builder: (context, state) {
          if (state is ReadingListLoading) {
            return const ReadingListShimmerLoading();
          }

          if (state is ReadingListError) {
            final offline = !NetworkManager.instance.currentConnectionStatus;
            return RefreshIndicator(
              onRefresh: () => context
                  .read<ReadingListCubit>()
                  .getAllReadingLists(forceRefresh: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: offline
                        ? OfflineStateView(
                            title: 'Offline',
                            message: state.message,
                            actionLabel: 'Retry',
                            onAction: () => context
                                .read<ReadingListCubit>()
                                .getAllReadingLists(forceRefresh: true),
                          )
                        : ErrorStateView(
                            title: 'Error',
                            message: state.message,
                            actionLabel: 'Retry',
                            onAction: () => context
                                .read<ReadingListCubit>()
                                .getAllReadingLists(forceRefresh: true),
                          ),
                  ),
                ],
              ),
            );
          }

          if (state is ReadingListsLoaded) {
            return RefreshIndicator(
              onRefresh: () => context
                  .read<ReadingListCubit>()
                  .getAllReadingLists(forceRefresh: true),
              child: state.readingLists.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Text(S.of(context).no_reading_lists_yet),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                        final readingList = state.readingLists[index];
                        return ReadingListCard(
                          readingList: readingList,
                          onTap: () => readingList.isPublic
                              ? context.push(
                                  RouteNames.readingListDetailsRoute(
                                    readingList.id,
                                  ),
                                  extra: readingList,
                                )
                              : null,
                        );
                      },
                      itemCount: state.readingLists.length,
                    ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
