import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../domain/entities/paper_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_shimmer_loading.dart';
import '../widgets/paper_card.dart';

class RecentelyPublishedScreen extends StatefulWidget {
  const RecentelyPublishedScreen({super.key});

  @override
  State<RecentelyPublishedScreen> createState() =>
      _RecentelyPublishedScreenState();
}

class _RecentelyPublishedScreenState extends State<RecentelyPublishedScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);

    // Load recent papers if not already loaded
    final cubit = context.read<HomeCubit>();
    if (cubit.state is! HomeRecentPapersLoaded &&
        cubit.state is! HomePapersLoaded) {
      cubit.getRecentPapers();
    }
  }

  void _onScroll() {
    final position = scrollController.position;
    // Check if scrolled near the bottom (within 300 pixels)
    if (position.pixels >= position.maxScrollExtent - 300) {
      final cubit = context.read<HomeCubit>();
      cubit.loadMoreRecentPapers();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 60),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leading: const MyBackIcon(),
                  title: Text(
                    S.of(context).recently_published,
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  centerTitle: true,
                ),
              );
            },
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
                  children: [
                    const HomeSearchBar(),
                    SizedBox(height: MySizes.spaceSm(context)),
                    const CategoryItemsList(selectedCategory: 'Science'),
                    SizedBox(height: MySizes.spaceSm(context)),
                    Expanded(
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoading) {
                            return const PaperListShimmer(itemCount: 5);
                          }

                          // Handle multiple state types
                          late List<PaperEntity> papers;
                          late bool isLoadingMore;

                          if (state is HomeRecentPapersLoaded) {
                            papers = state.recentPapers;
                            isLoadingMore = state.isLoadingMoreRecent;
                          } else if (state is HomePapersLoaded) {
                            papers = state.recentPapers;
                            isLoadingMore = state.isLoadingMoreRecent;
                          } else if (state is HomePapersUpdated) {
                            papers = state.recentPapers;
                            isLoadingMore = state.isLoadingMoreRecent;
                          } else {
                            return Center(
                              child: Text(S.of(context).data_not_loaded),
                            );
                          }

                          if (papers.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: MySizes.spaceMd(context)),
                                  Text(
                                    S.of(context).no_results_found,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: papers.length + (isLoadingMore ? 1 : 0),
                            separatorBuilder: (_, index) {
                              if (index >= papers.length - 1) {
                                return const SizedBox.shrink();
                              }
                              return SizedBox(height: MySizes.spaceMd(context));
                            },
                            itemBuilder: (context, index) {
                              if (index >= papers.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: MySizes.spaceMd(context),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final paper = papers[index];
                              return PaperCard(paper: paper);
                            },
                          );
                        },
                      ),
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
