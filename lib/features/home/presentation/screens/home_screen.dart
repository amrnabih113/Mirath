import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/section_title.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_shimmer_loading.dart';
import '../widgets/paper_card.dart';
import '../widgets/welcome_header.dart';

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
      cubit.loadMoreRecommendations();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().loadAllPapers();
  }

  @override
  Widget build(BuildContext context) {
    late List<PaperEntity> papers;
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
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return WelcomeHeader();
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              controller: scrollController,
              padding: MySizes.paddingMd(context),
              children: [
                const HomeSearchBar(),
                SizedBox(height: MySizes.spaceLg(context)),
                SectionTitle(
                  title: 'Recently Published',
                  onTap: () => context.push("/recentely-published"),
                ),
                SizedBox(height: MySizes.spaceMd(context)),
                const CategoryItemsList(),
                SizedBox(height: MySizes.spaceLg(context) * 1.5),
                SectionTitle(title: 'You might also like', showSeeAll: false),
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
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: MySizes.spaceLg(context) * 2,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: MySizes.spaceMd(context)),
                                    Text(
                                      'No papers available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                  context.push('/paper-screen', extra: paper);
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
      ),
    );
  }
}
