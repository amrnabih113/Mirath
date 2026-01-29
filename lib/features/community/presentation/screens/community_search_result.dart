import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/search_with_filter.dart';
import 'package:mirath/features/common/widgets/section_title.dart';
import 'package:mirath/features/community/presentation/widgets/discussion_card.dart';
import 'package:mirath/features/community/presentation/widgets/reading_list_card.dart';
import 'package:mirath/features/community/presentation/widgets/researcher_card.dart';
import 'package:mirath/features/home/presentation/widgets/category_items_list.dart';

import '../../../../core/utils/my_sizes.dart';

class CommunitySearchResult extends StatefulWidget {
  const CommunitySearchResult({super.key});

  @override
  State<CommunitySearchResult> createState() => _CommunitySearchResultState();
}

class _CommunitySearchResultState extends State<CommunitySearchResult> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Top';
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
        leading: MyBackIcon(),
        titleSpacing: 0,
        title: SearchWithFilter(searchController: TextEditingController()),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _CategoryHeaderDelegate(
                          context: context,
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: _onCategoryChanged,
                          child: Column(
                            children: [
                              CategoryItemsList(
                                selectedCategory: _selectedCategory,
                                categories: [
                                  "Top",
                                  "Discussions",
                                  "Reading Lists",
                                  "Researchers",
                                ],
                                onCategoryChanged: _onCategoryChanged,
                              ),
                              SizedBox(height: MySizes.spaceLg(context)),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedCategory == 'Top' ||
                          _selectedCategory == 'Researchers') ...[
                        SliverToBoxAdapter(
                          child: SectionTitle(
                            title: "Researchers",
                            showSeeAll: true,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceSm(context)),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MySizes.spaceXs(context),
                              ),
                              child: ResearcherCard(),
                            );
                          }, childCount: 3),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                        SliverToBoxAdapter(child: Divider()),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                      ],
                      if (_selectedCategory == 'Top' ||
                          _selectedCategory == 'Discussions') ...[
                        SliverToBoxAdapter(
                          child: SectionTitle(
                            title: "Discussions",
                            showSeeAll: true,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceSm(context)),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MySizes.spaceXs(context),
                              ),
                              child: DiscussionCard(),
                            );
                          }, childCount: 3),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                        SliverToBoxAdapter(child: Divider()),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                      ],
                      if (_selectedCategory == 'Top' ||
                          _selectedCategory == 'Reading Lists') ...[
                        SliverToBoxAdapter(
                          child: SectionTitle(
                            title: "Reading Lists",
                            showSeeAll: true,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceSm(context)),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MySizes.spaceXs(context),
                              ),
                              child: ReadingListCard(),
                            );
                          }, childCount: 3),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final BuildContext context;
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  _CategoryHeaderDelegate({
    required this.child,
    required this.context,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent =>
      ResponsiveHelper.responsiveValue(context, 50) + MySizes.spaceLg(context);

  @override
  double get minExtent =>
      ResponsiveHelper.responsiveValue(context, 50) + MySizes.spaceLg(context);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate is _CategoryHeaderDelegate) {
      return oldDelegate.selectedCategory != selectedCategory;
    }
    return false;
  }
}
