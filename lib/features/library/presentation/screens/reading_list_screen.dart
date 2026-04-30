import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/home_shimmer_loading.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';
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
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReadLaterContainer(),
                                  SizedBox(height: MySizes.spaceSm(context)),

                                  //your lists
                                  BlocBuilder<
                                    ReadingListCubit,
                                    ReadingListState
                                  >(
                                    builder: (context, state) {
                                      if (state is ReadingListLoading) {
                                        return const ReadingListShimmerLoading();
                                      } else if (state is ReadingListsLoaded) {
                                        return ListView.builder(
                                          shrinkWrap: true, // 👈 add this
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.readingLists.length,
                                          itemBuilder: (context, index) =>
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MySizes.spaceXs(
                                                    context,
                                                  ),
                                                ),
                                                child: ReadingListCard(
                                                  readingList:
                                                      state.readingLists[index],
                                                ),
                                              ),
                                        );
                                      } else if (state is ReadingListError) {
                                        return Text('Error: ${state.message}');
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            //saved lists
                            BlocBuilder<LibraryCubit, LibraryState>(
                              builder: (context, state) {
                                if (state is GetAllSavedPapersLoading) {
                                  return const PaperListShimmer();
                                } else if (state is GetAllSavedPapersSuccess) {
                                  return ListView.separated(
                                    padding: const EdgeInsets.all(8),

                                    itemCount: state.savedPapers.length,

                                    itemBuilder: (context, index) => PaperCard(
                                      savedPaper: state.savedPapers[index],
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
                                } else if (state is GetAllSavedPapersFailure) {
                                  return Text(state.errorMessage);
                                } else {
                                  return const SizedBox();
                                }
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
