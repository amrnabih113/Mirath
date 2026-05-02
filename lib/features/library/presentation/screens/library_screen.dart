import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/generated/l10n.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';
import 'package:mirath/features/library/presentation/widgets/lib_tiles.dart';
import 'package:mirath/features/library/presentation/widgets/my_item.dart';
import 'package:mirath/features/library/presentation/widgets/my_item_shimmer.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_state.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).your_library,
          style: context.headlineLarge.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          BlocListener<ReadingListCubit, ReadingListState>(
            listener: (context, state) {
              if (state is ReadingListOperationSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is ReadingListError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedPlusSign,
                size: MySizes.iconMedium(context),
              ),
              onPressed: () {
                context.read<ReadingListCubit>().addPaperToList(
                  readingListId: 'reading_list_id_here',
                  paperId: 'paper_id_here',
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocBuilder<LibraryCubit, LibraryState>(
                      builder: (context, state) {
                        if (state is LibraryDataLoading) {
                          return const MyItemShimmer();
                        } else if (state is LibraryDataSuccess) {
                          return MyItem(data: state.libraryData);
                        } else if (state is LibraryDataFailure) {
                          return Text('Error: ${state.errorMessage}');
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: MySizes.spaceLg(context) * 1.25),
                    LibTiles(
                      title: S.of(context).projects,
                      onTap: () {
                        context.push('/projects');
                      },
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    LibTiles(
                      title: S.of(context).reading_lists,
                      onTap: () {
                        context.push('/reading-lists');
                      },
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    LibTiles(
                      title: S.of(context).reading_history,
                      onTap: () {
                        context.push('/reading-history');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
