import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/my_sizes.dart';
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
      create: (_) => sl<ReadingListCubit>()..getUserReadingLists(),
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
              return const Center(child: Text('No reading lists yet'));
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
                  onTap: () =>
                      context.push('/reading-list-details', extra: readingList),
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
