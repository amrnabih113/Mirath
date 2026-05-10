import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../domain/entities/paper_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_shimmer_loading.dart';
import '../widgets/interests_shimmer_loading.dart';
import '../widgets/paper_card.dart';

class RecentelyPublishedScreen extends StatefulWidget {
  final String? selectedCategory;

  const RecentelyPublishedScreen({super.key, this.selectedCategory});

  @override
  State<RecentelyPublishedScreen> createState() =>
      _RecentelyPublishedScreenState();
}

class _RecentelyPublishedScreenState extends State<RecentelyPublishedScreen> {
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);

    // Load recent papers with selected category if provided
    final cubit = context.read<HomeCubit>();
    if (cubit.state is! HomeRecentPapersLoaded &&
        cubit.state is! HomePapersLoaded &&
        cubit.state is! HomePapersUpdated) {
      if (widget.selectedCategory != null) {
        cubit.getRecentPapers(category: widget.selectedCategory);
      } else {
        cubit.getRecentPapers();
      }
    } else if (widget.selectedCategory != null) {
      // If papers already loaded, filter by category
      cubit.filterPapersByInterest(widget.selectedCategory!);
    }
  }

  void _onScroll() {
    final position = scrollController.position;
    // Check if scrolled near the bottom (within 300 pixels)
    if (position.pixels >= position.maxScrollExtent - 300) {
      final cubit = context.read<HomeCubit>();
      cubit.loadMoreRecentPapers(category: widget.selectedCategory);
    }
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
    });
  }

  @override
  void didUpdateWidget(RecentelyPublishedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the selectedCategory changed, update the filter
    if (oldWidget.selectedCategory != widget.selectedCategory &&
        widget.selectedCategory != null) {
      context.read<HomeCubit>().filterPapersByInterest(
        widget.selectedCategory!,
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
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
                    // Custom search bar for filtering categories
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          MySizes.borderRadiusMd(context),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primaryShade900.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        cursorColor: MyColors.primaryShade500,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: MySizes.spaceSm(context),
                            horizontal: MySizes.spaceMd(context),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: MySizes.spaceSm(context),
                              right: MySizes.spaceXs(context),
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedSearch01,
                            ),
                          ),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      searchQuery = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              : null,
                          hintText: 'Search categories...',
                          hintStyle: context.bodySmall,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MySizes.borderRadiusMd(context),
                            ),
                            borderSide: BorderSide(
                              color: MyColors.primaryShade50,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MySizes.borderRadiusMd(context),
                            ),
                            borderSide: BorderSide(
                              color: MyColors.primaryShade50,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MySizes.borderRadiusMd(context),
                            ),
                            borderSide: BorderSide(
                              color: MyColors.primaryShade500,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MySizes.spaceSm(context)),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is HomePapersLoaded) {
                          // Filter categories based on search query
                          final filteredCategories = state.categories
                              .where(
                                (category) => category.toLowerCase().contains(
                                  searchQuery,
                                ),
                              )
                              .toList();

                          return CategoryItemsList(
                            categories: filteredCategories,
                            selectedInterest: state.selectedCategory,
                            onInterestChanged: (interestName) {
                              context.read<HomeCubit>().filterPapersByInterest(
                                interestName,
                              );
                            },
                          );
                        } else if (state is HomePapersUpdated) {
                          // Filter categories based on search query
                          final filteredCategories = state.categories
                              .where(
                                (category) => category.toLowerCase().contains(
                                  searchQuery,
                                ),
                              )
                              .toList();

                          return CategoryItemsList(
                            categories: filteredCategories,
                            selectedInterest: state.selectedCategory,
                            onInterestChanged: (interestName) {
                              context.read<HomeCubit>().filterPapersByInterest(
                                interestName,
                              );
                            },
                          );
                        }
                        return const InterestsShimmerLoading();
                      },
                    ),
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
                              return PaperCard(
                                paper: paper,
                                onTap: () {
                                  context.push(
                                    RouteNames.paperDetailsRoute(paper.id),
                                    extra: paper,
                                  );
                                },
                              );
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
