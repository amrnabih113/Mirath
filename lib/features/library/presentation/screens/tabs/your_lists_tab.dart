import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/library/presentation/widgets/read_later_container.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_state.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_card.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_shimmer_loading.dart';
import 'package:mirath/injection/injection_container.dart';

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
                padding: EdgeInsets.zero,
                children: [
                  const ReadLaterContainer(),
                  SizedBox(height: MySizes.spaceSm(context)),
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
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.readingLists.length,
              itemBuilder: (context, index) {
                final item = state.readingLists[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: MySizes.spaceXs(context)),
                  child: ReadingListCard(
                    readingList: item,
                    onTap: () {
                      context.push(RouteNames.readingListDetailsRoute(item.id), extra: item);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(height: MySizes.spaceSm(context));
                }
                return SizedBox(height: MySizes.spaceXs(context));
              },
            );
          }

          if (state is ReadingListError) {
            return ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const ReadLaterContainer(),
                SizedBox(height: MySizes.spaceSm(context)),
                Center(child: Text(state.message)),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
