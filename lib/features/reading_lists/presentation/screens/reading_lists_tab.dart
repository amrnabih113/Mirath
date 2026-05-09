import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';

import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../cubit/reading_list_cubit.dart';
import '../cubit/reading_list_state.dart';
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
            return Center(child: Text(state.message));
          }

          if (state is ReadingListsLoaded) {
            if (state.readingLists.isEmpty) {
              return Center(child: Text(S.of(context).no_reading_lists_yet));
            }

            return ListView.separated(
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
                          RouteNames.readingListDetailsRoute(readingList.id),
                          extra: readingList,
                        )
                      : null,
                );
              },
              itemCount: state.readingLists.length,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
