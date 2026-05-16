import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../cubit/library_cubit.dart';
import '../widgets/lib_tiles.dart';
import '../widgets/my_item.dart';
import '../widgets/my_item_shimmer.dart';

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
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (state.fromCache)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.wifi_off_rounded,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Showing cached data',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              if (state.fromCache)
                                SizedBox(height: MySizes.spaceSm(context)),
                              MyItem(data: state.libraryData),
                            ],
                          );
                        } else if (state is LibraryDataFailure) {
                          return Text('Error: ${state.errorMessage}');
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: MySizes.spaceLg(context) * 1.25),
                    LibTiles(
                      title: "Read Later", //S.of(context).reading_later,
                      onTap: () {
                        context.push('/read-later');
                      },
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
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
