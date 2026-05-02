import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/home_shimmer_loading.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';
import 'package:mirath/features/library/presentation/widgets/read_later_container.dart';
import 'package:mirath/features/library/presentation/widgets/show_create_list_dialog.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_state.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_card.dart';
import 'package:mirath/features/reading_lists/presentation/widgets/reading_list_shimmer_loading.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: MyBackIcon(),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedPlusSign,
                size: MySizes.iconMedium(context),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateListDialog(),
                );
              },
            ),
          ],
        ),

        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: MyColors.primaryShade900,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Your Lists'),
                        Tab(text: 'Saved lists'),
                      ],
                    ),

                    Expanded(
                      child: Padding(
                        padding: MySizes.paddingSm(context),
                        child: TabBarView(
                          children: [
                            // YOUR LISTS TAB
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ReadLaterContainer(),
                                  SizedBox(height: MySizes.spaceSm(context)),

                                  BlocBuilder<
                                    ReadingListCubit,
                                    ReadingListState
                                  >(
                                    builder: (context, state) {
                                      if (state is ReadingListLoading) {
                                        return const ReadingListShimmerLoading();
                                      }

                                      if (state is ReadingListsLoaded) {
                                        if (state.readingLists.isEmpty) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'You haven’t created any lists',
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Explore',
                                                    style: context.bodyLarge
                                                        .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationThickness:
                                                              2,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemCount:
                                                state.readingLists.length,
                                            itemBuilder: (context, index) {
                                              final item =
                                                  state.readingLists[index];

                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MySizes.spaceXs(
                                                    context,
                                                  ),
                                                ),
                                                child: ReadingListCard(
                                                  readingList: item,
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (
                                                  BuildContext context,
                                                  int index,
                                                ) => SizedBox(
                                                  height: MySizes.spaceXs(
                                                    context,
                                                  ),
                                                ),
                                          );
                                        }
                                      }

                                      if (state is ReadingListError) {
                                        return Center(
                                          child: Text(state.message),
                                        );
                                      }

                                      return const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // SAVED LISTS TAB
                            BlocBuilder<ReadingListCubit, ReadingListState>(
                              builder: (context, state) {
                                if (state is ReadingListLoading) {
                                  return const PaperListShimmer();
                                }

                                if (state is ReadingListsLoaded) {
                                  if (state.readingLists.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'You haven’t added any Saved papers',
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Explore',
                                              style: context.bodyLarge.copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return ListView.separated(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: state.readingLists.length,
                                    itemBuilder: (context, index) => PaperCard(
                                      readingList: state.readingLists[index],
                                      onTap: () {
                                        context.push(
                                          '/other-user-reading-list',
                                        );
                                      },
                                    ),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height:
                                              MySizes.spaceXs(context) * 0.5,
                                        ),
                                  );
                                }

                                if (state is ReadingListError) {
                                  return Center(child: Text(state.message));
                                }

                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
