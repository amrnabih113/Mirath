import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
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
    //scrollController.addListener(_onScroll);
  }

  // void _onScroll() {
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     final cubit = context.read<HomeCubit>();
  //     cubit.loadMoreRecentPapers();
  //   }
  // }

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
                            return const PaperListShimmer(itemCount: 5);
                          }

                          if (state is HomeRecentPapersLoaded) {
                            final papers = state.recentPapers;

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
                                      'No papers available',
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
                              itemCount: papers.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: MySizes.spaceMd(context)),
                              itemBuilder: (context, index) {
                                final paper = papers[index];
                                return PaperCard(paper: paper);
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
