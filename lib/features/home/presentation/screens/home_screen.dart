import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/ui/widgets/state_views.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/section_title.dart';
import '../../domain/entities/paper_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_shimmer_loading.dart';
import '../widgets/interests_shimmer_loading.dart';
import '../widgets/paper_card.dart';
import '../widgets/welcome_header.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);

    // Load data only if not already loaded
    final cubit = context.read<HomeCubit>();
    if (cubit.state is HomeInitial) {
      cubit.loadAllPapers();
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

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().loadAllPapers(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    late List<PaperEntity> papers;
    return Scaffold(
      appBar: MyAppBar(
        height: ResponsiveHelper.responsiveValue(context, 60),
        title: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return const WelcomeHeader();
          },
        ),
      ),
      body: MyBody(
        padding: MySizes.paddingMd(context),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            controller: scrollController,
              children: [
                const HomeSearchBar(),
                SizedBox(height: MySizes.spaceLg(context)),
                SectionTitle(
                  title: S.of(context).recently_published,
                  onTap: () {
                    final cubit = context.read<HomeCubit>();
                    final state = cubit.state;
                    if (state is HomePapersLoaded) {
                      context.push(
                        RouteNames.recentlyPublished,
                        extra: state.selectedCategory,
                      );
                    } else {
                      context.push(RouteNames.recentlyPublished);
                    }
                  },
                ),
                SizedBox(height: MySizes.spaceMd(context)),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    // Treat updated state (HomePapersUpdated) the same as the
                    // loaded state so UI sections (categories) don't fall back
                    // to a loading shimmer during optimistic updates.
                    if (state is HomePapersLoaded ||
                        state is HomePapersUpdated) {
                      final categories = state is HomePapersLoaded
                          ? state.categories
                          : (state as HomePapersUpdated).categories;
                      final selected = state is HomePapersLoaded
                          ? state.selectedCategory
                          : (state as HomePapersUpdated).selectedCategory;

                      return CategoryItemsList(
                        categories: categories,
                        selectedInterest: selected,
                        maxItems: 10,
                        onInterestChanged: (interestName) {
                          context.push(
                            RouteNames.recentlyPublished,
                            extra: interestName,
                          );
                        },
                      );
                    }

                    return const InterestsShimmerLoading();
                  },
                ),
                SizedBox(height: MySizes.spaceLg(context) * 1.5),
                SectionTitle(
                  title: S.of(context).you_might_also_like,
                  showSeeAll: false,
                ),
                SizedBox(height: MySizes.spaceMd(context)),

                // BlocBuilder only for the papers list section
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state is HomePapersUpdated) {
                      // Update local papers list when papers are updated

                      setState(() {
                        papers = state.recentPapers;
                      });
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return const PaperListShimmer();
                        }

                        if (state is HomeError) {
                          final isOffline =
                              state.message.toLowerCase().contains(
                                'internet',
                              ) ||
                              state.message.toLowerCase().contains('network');

                          return isOffline
                              ? OfflineStateView(
                                  title: 'You are offline',
                                  message:
                                      'We could not load fresh papers. Connect to the internet or browse your cached content.',
                                  actionLabel: S.of(context).retry_button,
                                  onAction: () => context
                                      .read<HomeCubit>()
                                      .loadAllPapers(forceRefresh: true),
                                )
                              : ErrorStateView(
                                  title: 'Something went wrong',
                                  message: state.message,
                                  actionLabel: S.of(context).retry_button,
                                  onAction: () => context
                                      .read<HomeCubit>()
                                      .loadAllPapers(forceRefresh: true),
                                );
                        }

                        if (state is HomePapersLoaded ||
                            state is HomePapersUpdated) {
                          late List<PaperEntity> recentPapers;
                          late bool isLoadingMore;

                          if (state is HomePapersLoaded) {
                            recentPapers = state.recentPapers;
                            isLoadingMore = state.isLoadingMoreRecent;
                          } else if (state is HomePapersUpdated) {
                            recentPapers = state.recentPapers;
                            isLoadingMore = state.isLoadingMoreRecent;
                          }

                          papers = recentPapers;

                          // Handle empty papers list
                          if (papers.isEmpty) {
                            return EmptyStateView(
                              icon: Icons.article_outlined,
                              title: 'No papers available',
                              message:
                                  'There is nothing to show right now. Try again later or refresh when you are online.',
                              actionLabel: S.of(context).retry_button,
                              onAction: () => context
                                  .read<HomeCubit>()
                                  .loadAllPapers(forceRefresh: true),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                        }

                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
                SizedBox(height: MySizes.spaceLg(context) * 4),
              ],
            ),
          ),
        ),
      );
  }
}
