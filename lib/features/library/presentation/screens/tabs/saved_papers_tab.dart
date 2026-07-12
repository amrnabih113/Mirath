import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/route_names.dart';
import '../../../../../core/network/network_manager.dart';
import '../../../../../core/ui/widgets/state_views.dart';
import '../../../../../core/utils/my_extenstions.dart';
import '../../../../../core/utils/my_sizes.dart';
import '../../../../../injection/injection_container.dart';
import '../../../../reading_lists/presentation/cubit/reading_list_cubit.dart';
import '../../../../reading_lists/presentation/cubit/reading_list_state.dart';
import '../../../../reading_lists/presentation/widgets/reading_list_card.dart';
import '../../../../reading_lists/presentation/widgets/reading_list_shimmer_loading.dart';

class SavedPapersTab extends StatelessWidget {
  const SavedPapersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadingListCubit>(
      create: (context) => sl<ReadingListCubit>()..getSavedReadingLists(),
      child: BlocBuilder<ReadingListCubit, ReadingListState>(
        builder: (context, state) {
          if (state is ReadingListLoading) {
            return const ReadingListShimmerLoading();
          }

          if (state is ReadingListsLoaded) {
            final savedListsList = state.readingLists;

            if (savedListsList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You haven\'t added any Saved lists'),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Explore',
                        style: context.bodyLarge.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.only(
                top: MySizes.spaceSm(context),
                bottom:
                    kBottomNavigationBarHeight +
                    MySizes.spaceMd(context) +
                    MediaQuery.of(context).padding.bottom,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: savedListsList.length,
              itemBuilder: (context, index) {
                final item = savedListsList[index];

                return ReadingListCard(
                  readingList: item,
                  onTap: () {
                    context.push(
                      RouteNames.readingListDetailsRoute(item.id),
                      extra: item,
                    );
                  },
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: MySizes.spaceMd(context)),
            );
          }

          if (state is ReadingListError) {
            final offline = !NetworkManager.instance.currentConnectionStatus;
            return offline
                ? OfflineStateView(
                    title: 'Offline',
                    message: state.message,
                    actionLabel: 'Retry',
                    onAction: () => context
                        .read<ReadingListCubit>()
                        .getSavedReadingLists(forceRefresh: true),
                  )
                : ErrorStateView(
                    title: 'Error',
                    message: state.message,
                    actionLabel: 'Retry',
                    onAction: () => context
                        .read<ReadingListCubit>()
                        .getSavedReadingLists(forceRefresh: true),
                  );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
