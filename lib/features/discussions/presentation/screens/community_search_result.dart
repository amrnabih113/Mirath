import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/generated/l10n.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/search_with_filter.dart';
import '../../../common/widgets/section_title.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../../../reading_lists/domain/entities/reading_list_owner.dart';
import '../cubit/community_cubit.dart';
import '../cubit/community_state.dart';
import '../widgets/discussion_card.dart';
import '../../../reading_lists/presentation/widgets/reading_list_card.dart';
import '../widgets/researcher_card.dart';

import '../../../../core/utils/my_sizes.dart';

class CommunitySearchResult extends StatefulWidget {
  const CommunitySearchResult({super.key});

  @override
  State<CommunitySearchResult> createState() => _CommunitySearchResultState();
}

class _CommunitySearchResultState extends State<CommunitySearchResult> {
  String _selectedCategory = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedCategory.isEmpty) {
      _selectedCategory = S.of(context).top_label;
    }
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
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 60),
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
                              // CategoryItemsList(
                              //   selectedCategory: _selectedCategory,
                              //   categories: [
                              //     S.of(context).top_label,
                              //     S.of(context).discussions_label,
                              //     S.of(context).reading_lists,
                              //     S.of(context).researchers_label,
                              //   ],
                              //   onCategoryChanged: _onCategoryChanged,
                              // ),
                              SizedBox(height: MySizes.spaceLg(context)),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedCategory == S.of(context).top_label ||
                          _selectedCategory ==
                              S.of(context).researchers_label) ...[
                        SliverToBoxAdapter(
                          child: SectionTitle(
                            title: S.of(context).researchers_label,
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
                      if (_selectedCategory == S.of(context).top_label ||
                          _selectedCategory ==
                              S.of(context).discussions_label) ...[
                        SliverToBoxAdapter(
                          child: SectionTitle(
                            title: S.of(context).discussions_label,
                            showSeeAll: true,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceSm(context)),
                        ),
                        BlocBuilder<CommunityCubit, CommunityState>(
                          builder: (context, state) {
                            if (state is CommunityDiscussionsLoaded) {
                              final discussions = state.discussions
                                  .take(3)
                                  .toList();

                              if (discussions.isEmpty) {
                                return SliverToBoxAdapter(
                                  child: Center(
                                    child: Text(
                                      S.of(context).no_discussions_found,
                                    ),
                                  ),
                                );
                              }

                              return SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MySizes.spaceXs(context),
                                    ),
                                    child: DiscussionCard(
                                      discussion: discussions[index],
                                    ),
                                  );
                                }, childCount: discussions.length),
                              );
                            }

                            return SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    MySizes.spaceMd(context),
                                  ),
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                            );
                          },
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                        SliverToBoxAdapter(child: Divider()),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                      ],
                      if (_selectedCategory == S.of(context).top_label ||
                          _selectedCategory == S.of(context).reading_lists) ...[
                        SliverToBoxAdapter(
                          child: SectionTitle(
                            title: S.of(context).reading_lists,
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
                            // Mock reading list data for search results
                            final mockReadingList = ReadingList(
                              id: 'mock-$index',
                              title:
                                  '${S.of(context).reading_list_item_title} ${index + 1}',
                              description: S
                                  .of(context)
                                  .mock_reading_list_description,
                              isPublic: true,
                              ownerId: 'mock-owner',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              paperCount: 5 + index,
                              previewTags: ['AI', 'ML', 'Research'],
                              owner: const ReadingListOwner(
                                id: 'mock-owner',
                                username: 'researcher',
                                fullName: 'Mock Researcher',
                              ),
                            );

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MySizes.spaceXs(context),
                              ),
                              child: ReadingListCard(
                                readingList: mockReadingList,
                              ),
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
