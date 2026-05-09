import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/my_search_bar.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/paper_card.dart';

class HomeSearchResultScreen extends StatefulWidget {
  const HomeSearchResultScreen({super.key});

  @override
  State<HomeSearchResultScreen> createState() => _HomeSearchResultScreenState();
}

class _HomeSearchResultScreenState extends State<HomeSearchResultScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = GoRouterState.of(context).extra as String?;
      if (query != null && query.trim().isNotEmpty) {
        _controller.text = query;
        context.read<SearchCubit>().searchPapers(query, limit: _itemsPerPage);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMoreResults();
    }
  }

  void _loadMoreResults() {
    final state = context.read<SearchCubit>().state;
    if (state is SearchResultsLoaded &&
        !state.hasReachedMax &&
        !state.isLoadingMore) {
      context.read<SearchCubit>().loadMorePapers(limit: _itemsPerPage);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 60),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 850),
                  child: AppBar(
                    toolbarHeight: ResponsiveHelper.responsiveValue(
                      context,
                      60,
                    ),
                    leadingWidth: ResponsiveHelper.responsiveValue(context, 60),
                    leading: MyBackIcon(),
                    titleSpacing: 0,
                    title: MySearchBar(
                      controller: _controller,
                      hintText: S.of(context).search_papers_authors_keywords,
                      showSuffixIcon: false,
                      onSubmitted: (value) {
                        context.read<SearchCubit>().searchPapers(value);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SearchError) {
            return Center(child: Text(state.message));
          }

          if (state is SearchResultsLoaded) {
            final results = state.results;

            if (results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: MyColors.primaryShade300,
                    ),
                    SizedBox(height: MySizes.spaceMd(context)),
                    Text(
                      S.of(context).no_results_found,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.primaryShade700,
                      ),
                    ),
                    SizedBox(height: MySizes.spaceXs(context)),
                    Text(
                      S.of(context).try_searching_with_different_keywords,
                      style: TextStyle(
                        fontSize: 14,
                        color: MyColors.primaryShade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Padding(
                      padding: MySizes.paddingMd(context),
                      child: ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: MySizes.spaceXs(context)),
                        padding: EdgeInsets.only(
                          top: ResponsiveHelper.responsiveValue(context, 16),
                          bottom: ResponsiveHelper.responsiveValue(context, 16),
                        ),
                        itemBuilder: (context, index) {
                          if (index >= results.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            );
                          }
                          return PaperCard(
                            paper: results[index],
                            onTap: () {
                              context.push(
                                RouteNames.paperDetailsRoute(results[index].id),
                                extra: results[index],
                              );
                            },
                          );
                        },
                        itemCount:
                            results.length + (state.isLoadingMore ? 1 : 0),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(child: Text(S.of(context).start_searching));
        },
      ),
    );
  }
}
