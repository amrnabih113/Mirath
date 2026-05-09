import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_state.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_card.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_shimmer_loading.dart';
import 'package:mirath/injection/injection_container.dart';

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
              padding: const EdgeInsets.all(8),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: savedListsList.length,
              itemBuilder: (context, index) {
                final item = savedListsList[index];

                return ReadingListCard(
                  readingList: item,
                  onTap: () {
                    context.push('/reading-list-details', extra: item);
                  },
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: MySizes.spaceXs(context) * 0.5),
            );
          }

          if (state is ReadingListError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
