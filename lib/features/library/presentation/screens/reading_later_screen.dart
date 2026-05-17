import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_formaters.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../home/presentation/widgets/home_shimmer_loading.dart';
import '../../../home/presentation/widgets/paper_card.dart';
import '../cubit/library_cubit.dart';

class ReadingLaterScreen extends StatefulWidget {
  const ReadingLaterScreen({super.key});

  @override
  State<ReadingLaterScreen> createState() => _ReadingLaterScreenState();
}

class _ReadingLaterScreenState extends State<ReadingLaterScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh saved papers when coming back to the screen
      context.read<LibraryCubit>().getAllSavedPapers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(leading: MyBackIcon()),
      body: MyBody(
        padding: EdgeInsets.zero,
        child: BlocBuilder<LibraryCubit, LibraryState>(
          builder: (context, state) {
            if (state is GetAllSavedPapersLoading) {
              // Show the static header immediately, but only shimmer the
              // list area so static data doesn't flicker during load.
              return Padding(
                padding: MySizes.paddingMd(context),
                child: CustomScrollView(
                  slivers: [
                    // HEADER (static while loading)
                    SliverToBoxAdapter(
                      child: Container(
                        height: ResponsiveHelper.responsiveValue(context, 100),
                        width: MySizes.screenWidth(context),

                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: MyColors.primaryShade100,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Read Later',
                              style: context.headlineSmall.copyWith(
                                color: MyColors.primaryShade900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: MySizes.spaceSm(context) * 0.5),

                            // Keep a stable subtitle while loading
                            Text('Loading…'),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: MySizes.spaceMd(context)),
                    ),

                    // SHIMMER ONLY FOR THE LIST
                    SliverToBoxAdapter(child: PaperListShimmer()),
                  ],
                ),
              );
            }

            if (state is GetAllSavedPapersFailure) {
              return Center(child: Text(state.errorMessage));
            }

            if (state is GetAllSavedPapersSuccess) {
              final savedPapersList = state.savedPapers;
              final formattedDate = savedPapersList.isEmpty
                  ? '0'
                  : MyFormaters.relativeTime(savedPapersList.first.createdAt);

              return Padding(
                padding: MySizes.paddingMd(context),
                child: CustomScrollView(
                  slivers: [
                    // HEADER
                    SliverToBoxAdapter(
                      child: Container(
                        height: ResponsiveHelper.responsiveValue(context, 100),
                        width: MySizes.screenWidth(context),

                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: MyColors.primaryShade100,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Read Later',
                              style: context.headlineSmall.copyWith(
                                color: MyColors.primaryShade900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: MySizes.spaceSm(context) * 0.5),

                            Text(
                              '${savedPapersList.length} papers • Updated $formattedDate',
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: MySizes.spaceMd(context)),
                    ),

                    // EMPTY STATE
                    if (savedPapersList.isEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('You haven’t added any research papers'),
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
                      )
                    else
                      // LIST
                      SliverList.separated(
                        itemCount: savedPapersList.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: MySizes.spaceSm(context)),
                        itemBuilder: (context, index) {
                          final paper = savedPapersList[index].paper;

                          return PaperCard(
                            paper: paper,
                            onTap: () {
                              context.push('/paper-screen', extra: paper);
                            },
                          );
                        },
                      ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
