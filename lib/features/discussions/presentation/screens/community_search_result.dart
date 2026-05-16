import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/my_search_bar.dart';
import '../../../common/widgets/section_title.dart';
import '../../../discussions/domain/entities/discussion.dart';
import '../../../home/presentation/widgets/category_items_list.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../../../reading_lists/presentation/widgets/reading_list_card.dart';
import '../../../users/domain/entities/user.dart';
import '../cubit/global_search_cubit.dart';
import '../cubit/global_search_state.dart';
import '../widgets/discussion_card.dart';
import '../widgets/researcher_card.dart';

class CommunitySearchResult extends StatefulWidget {
  const CommunitySearchResult({super.key, this.initialQuery, this.initialScope});

  final String? initialQuery;
  final GlobalSearchScope? initialScope;

  @override
  State<CommunitySearchResult> createState() => _CommunitySearchResultState();
}

class _CommunitySearchResultState extends State<CommunitySearchResult> {
  late final TextEditingController _searchController;

  GlobalSearchScope _selectedScope = GlobalSearchScope.top;
  bool _didTriggerInitialSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _selectedScope = widget.initialScope ?? GlobalSearchScope.top;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didTriggerInitialSearch) {
      final initialHasQuery = _searchController.text.trim().isNotEmpty;
      final hasScope = widget.initialScope != null;

      if (initialHasQuery || hasScope) {
        _didTriggerInitialSearch = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _runSearch(_searchController.text);
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    final cubit = context.read<GlobalSearchCubit>();

    switch (_selectedScope) {
      case GlobalSearchScope.top:
        await cubit.searchTop(query);
        break;
      case GlobalSearchScope.discussions:
        await cubit.searchDiscussions(query);
        break;
      case GlobalSearchScope.readingLists:
        await cubit.searchReadingLists(query);
        break;
      case GlobalSearchScope.researchers:
        await cubit.searchResearchers(query);
        break;
    }
  }

  void _onScopeSelected(GlobalSearchScope scope) {
    setState(() => _selectedScope = scope);

    final query = _searchController.text.trim();
    if (query.isNotEmpty) _runSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 72),
        leading: const MyBackIcon(),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 56),
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
          child: MySearchBar(
            controller: _searchController,
            hintText: S.of(context).search_placeholder,
            onSubmitted: _runSearch,
            onChanged: (value) {
              if (value.trim().isEmpty) {
                context.read<GlobalSearchCubit>().reset();
              }
            },
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: BlocBuilder<GlobalSearchCubit, GlobalSearchState>(
                  builder: (context, state) {
                    if (state.status == GlobalSearchStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final showPrompt =
                        state.status == GlobalSearchStatus.initial &&
                        state.query.isEmpty;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: showPrompt
                          ? _buildPrompt(context)
                          : _buildResults(context, state),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// PROMPT
  Widget _buildPrompt(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MySizes.spaceLg(context)),
        _scopeChips(context),
      ],
    );
  }

  /// RESULTS
  Widget _buildResults(BuildContext context, GlobalSearchState state) {
    final r = state.results;

    final hasResults =
        r.researchers.isNotEmpty ||
        r.discussions.isNotEmpty ||
        r.readingLists.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// FIXED FILTERS
        _scopeChips(context),

        SizedBox(height: MySizes.spaceLg(context)),

        Expanded(
          child: !hasResults
              ? const Center(child: Text('No results found'))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.scope == GlobalSearchScope.top) ...[
                        if (r.researchers.isNotEmpty)
                          _buildResearchersSection(context, r.researchers),

                        if (r.discussions.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              top: MySizes.spaceMd(context),
                            ),
                            child: _buildDiscussionsSection(
                              context,
                              r.discussions,
                            ),
                          ),

                        if (r.readingLists.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              top: MySizes.spaceMd(context),
                            ),
                            child: _buildReadingListsSection(
                              context,
                              r.readingLists,
                            ),
                          ),
                      ] else if (state.scope ==
                          GlobalSearchScope.discussions) ...[
                        if (r.discussions.isNotEmpty)
                          _buildDiscussionsSection(
                            context,
                            r.discussions,
                            showAll: true,
                          ),
                      ] else if (state.scope ==
                          GlobalSearchScope.readingLists) ...[
                        if (r.readingLists.isNotEmpty)
                          _buildReadingListsSection(
                            context,
                            r.readingLists,
                            showAll: true,
                          ),
                      ] else ...[
                        if (r.researchers.isNotEmpty)
                          _buildResearchersSection(
                            context,
                            r.researchers,
                            showAll: true,
                          ),
                      ],

                      SizedBox(height: MySizes.spaceLg(context)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  /// FILTERS
  Widget _scopeChips(BuildContext context) {
    return CategoryItemsList(
      categories: [
        S.of(context).top_label,
        S.of(context).discussions_label,
        S.of(context).reading_lists,
        S.of(context).researchers_label,
      ],
      showAllTab: false,
      selectedInterest: _scopeLabel(_selectedScope),
      onInterestChanged: (c) {
        final scope = _scopeFromLabel(c);
        if (scope != null) _onScopeSelected(scope);
      },
    );
  }

  String _scopeLabel(GlobalSearchScope scope) {
    switch (scope) {
      case GlobalSearchScope.top:
        return S.of(context).top_label;
      case GlobalSearchScope.discussions:
        return S.of(context).discussions_label;
      case GlobalSearchScope.readingLists:
        return S.of(context).reading_lists;
      case GlobalSearchScope.researchers:
        return S.of(context).researchers_label;
    }
  }

  GlobalSearchScope? _scopeFromLabel(String c) {
    if (c == S.of(context).top_label) {
      return GlobalSearchScope.top;
    }
    if (c == S.of(context).discussions_label) {
      return GlobalSearchScope.discussions;
    }
    if (c == S.of(context).reading_lists) {
      return GlobalSearchScope.readingLists;
    }
    if (c == S.of(context).researchers_label) {
      return GlobalSearchScope.researchers;
    }
    return null;
  }

  /// SECTIONS
  Widget _buildResearchersSection(
    BuildContext context,
    List<User> items, {
    bool showAll = false,
  }) {
    return _SearchSectionShell<User>(
      title: S.of(context).researchers_label,
      items: items,
      showAll: showAll,
      onSeeAll: () => _onScopeSelected(GlobalSearchScope.researchers),
      itemBuilder: (u) => ResearcherCard(user: u),
    );
  }

  Widget _buildDiscussionsSection(
    BuildContext context,
    List<Discussion> items, {
    bool showAll = false,
  }) {
    return _SearchSectionShell<Discussion>(
      title: S.of(context).discussions_label,
      items: items,
      showAll: showAll,
      onSeeAll: () => _onScopeSelected(GlobalSearchScope.discussions),
      itemBuilder: (d) => DiscussionCard(
        discussion: d,
        onTap: () => context.push(
          RouteNames.discussionDetailsRoute(d.id),
          extra: d,
        ),
      ),
    );
  }

  Widget _buildReadingListsSection(
    BuildContext context,
    List<ReadingList> items, {
    bool showAll = false,
  }) {
    return _SearchSectionShell<ReadingList>(
      title: S.of(context).reading_lists,
      items: items,
      showAll: showAll,
      onSeeAll: () => _onScopeSelected(GlobalSearchScope.readingLists),
      itemBuilder: (r) => ReadingListCard(
        readingList: r,
        onTap: () =>
            context.push(RouteNames.readingListDetailsRoute(r.id), extra: r),
      ),
    );
  }
}

/// SECTION SHELL
class _SearchSectionShell<T> extends StatelessWidget {
  const _SearchSectionShell({
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onSeeAll,
    this.showAll = false,
  });

  final String title;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final VoidCallback onSeeAll;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    final visible = showAll ? items : items.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: title,
          showSeeAll: items.length > 3 && !showAll,
          onTap: onSeeAll,
        ),
        SizedBox(height: MySizes.spaceSm(context)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visible.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: MySizes.spaceSm(context)),
          itemBuilder: (_, i) => itemBuilder(visible[i]),
        ),
      ],
    );
  }
}
