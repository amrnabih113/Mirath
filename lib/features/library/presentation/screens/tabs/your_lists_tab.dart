import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/route_names.dart';
import '../../../../../core/utils/my_sizes.dart';
import '../../widgets/read_later_container.dart';
import '../../../../reading_lists/presentation/cubit/reading_list_cubit.dart';
import '../../../../reading_lists/presentation/cubit/reading_list_state.dart';
import '../../../../reading_lists/presentation/widgets/reading_list_card.dart';
import '../../../../reading_lists/presentation/widgets/reading_list_shimmer_loading.dart';
import '../../../../../injection/injection_container.dart';
import '../../../../../core/network/network_manager.dart';
import '../../../../../core/ui/widgets/state_views.dart';

class YourListsTab extends StatelessWidget {
  const YourListsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadingListCubit>(
      create: (context) => sl<ReadingListCubit>()..getReadingLists(),
      child: BlocBuilder<ReadingListCubit, ReadingListState>(
        builder: (context, state) {
          if (state is ReadingListLoading) {
            return const ReadingListShimmerLoading();
          }

          if (state is ReadingListsLoaded) {
            if (state.readingLists.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: MySizes.spaceMd(context),
                  right: MySizes.spaceMd(context),
                  top: MySizes.spaceSm(context),
                  bottom:
                      kBottomNavigationBarHeight +
                      MySizes.spaceMd(context) +
                      MediaQuery.of(context).padding.bottom,
                ),
                children: [
                  const ReadLaterContainer(),
                  SizedBox(height: MySizes.spaceMd(context)),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MySizes.spaceLg(context),
                      ),
                      child: const Text('You haven\'t created any lists'),
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: EdgeInsets.only(
                left: MySizes.spaceMd(context),
                right: MySizes.spaceMd(context),
                top: MySizes.spaceSm(context),
                bottom:
                    kBottomNavigationBarHeight +
                    MySizes.spaceMd(context) +
                    MediaQuery.of(context).padding.bottom,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.readingLists.length,
              itemBuilder: (context, index) {
                final item = state.readingLists[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: MySizes.spaceXs(context)),
                  child: ReadingListCard(
                    readingList: item,
                    onTap: () {
                      context.push(
                        RouteNames.readingListDetailsRoute(item.id),
                        extra: item,
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: MySizes.spaceMd(context)),
            );
          }

          if (state is ReadingListError) {
            final offline = !NetworkManager.instance.currentConnectionStatus;
            return ListView(
              padding: EdgeInsets.only(
                left: MySizes.spaceMd(context),
                right: MySizes.spaceMd(context),
                top: MySizes.spaceSm(context),
                bottom:
                    kBottomNavigationBarHeight +
                    MySizes.spaceMd(context) +
                    MediaQuery.of(context).padding.bottom,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const ReadLaterContainer(),
                SizedBox(height: MySizes.spaceMd(context)),
                offline
                    ? OfflineStateView(
                        title: 'Offline',
                        message: state.message,
                        actionLabel: 'Retry',
                        onAction: () => context
                            .read<ReadingListCubit>()
                            .getReadingLists(forceRefresh: true),
                      )
                    : ErrorStateView(
                        title: 'Error',
                        message: state.message,
                        actionLabel: 'Retry',
                        onAction: () => context
                            .read<ReadingListCubit>()
                            .getReadingLists(forceRefresh: true),
                      ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
