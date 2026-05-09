import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/my_search_bar.dart';
import '../../domain/entities/search_history_item.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_item.dart';
import '../widgets/search_screen_heading.dart';

class SearchScreen extends StatefulWidget {
  final String hintText;
  final bool showHeading;

  const SearchScreen({
    this.hintText = 'Search',
    this.showHeading = true,
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchCubit>().loadSearchHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {});
  }

  void _onSubmitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    context.pushReplacement(RouteNames.homeSearchResults, extra: trimmed);
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
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 850),
                child: AppBar(
                  toolbarHeight: ResponsiveHelper.responsiveValue(context, 55),
                  leadingWidth: ResponsiveHelper.responsiveValue(context, 60),
                  leading: MyBackIcon(),
                  titleSpacing: 0,
                  title: Padding(
                    padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
                    child: MySearchBar(
                      controller: _searchController,
                      hintText: widget.hintText,
                      showSuffixIcon: false,
                      onChanged: _onQueryChanged,
                      onSubmitted: _onSubmitSearch,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.showHeading) ...[
                      SearchScreenHeading(
                        onClearAll: () =>
                            context.read<SearchCubit>().clearSearchHistory(),
                      ),
                      SizedBox(height: MySizes.spaceSm(context)),
                    ],
                    Expanded(
                      child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          if (state is SearchHistoryLoading ||
                              state is SearchInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is SearchError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }

                          final history = state is SearchHistoryLoaded
                              ? state.history
                              : <SearchHistoryItem>[];
                          final query = _searchController.text.trim();
                          final filtered = query.isEmpty
                              ? history
                              : history
                                    .where(
                                      (item) => item.query
                                          .toLowerCase()
                                          .contains(query.toLowerCase()),
                                    )
                                    .toList();

                          if (filtered.isEmpty) {
                            return Center(
                              child: Text(
                                'No recent searches',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }

                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: MySizes.spaceXs(context)),
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return InkWell(
                                onTap: () => _onSubmitSearch(item.query),
                                child: SearchItem(
                                  itemTitle: item.query,
                                  onTap: () => context
                                      .read<SearchCubit>()
                                      .deleteSearchHistoryItem(item.id),
                                ),
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
