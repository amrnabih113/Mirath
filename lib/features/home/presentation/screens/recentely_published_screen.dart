import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/home/presentation/cubit/home_state.dart';
import 'package:mirath/injection/injection_container.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
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
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
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
                    'Recently Published',
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is HomeRecentPapersLoaded) {
                            final papers = state.recentPapers;
                            final isLoadingMore = state.isLoadingMoreRecent;
                            final hasMore = !state.hasReachedMaxRecent;

                            return ListView.separated(
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  papers.length +
                                  (hasMore
                                      ? 1
                                      : 0), // +1 للspinner لو فيه بيانات زيادة
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: MySizes.spaceMd(context)),
                              itemBuilder: (context, index) {
                                if (index < papers.length) {
                                  return PaperCard(paper: papers[index]);
                                } else {
                                  // loading spinner
                                  return const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            );
                          }

                          return const Center(child: Text('Data not loaded'));
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
