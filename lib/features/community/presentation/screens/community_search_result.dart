import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/profile_avatar.dart';
import 'package:mirath/features/common/widgets/search_with_filter.dart';
import 'package:mirath/features/common/widgets/section_title.dart';
import 'package:mirath/features/community/presentation/widgets/discussion_card.dart';
import 'package:mirath/features/community/presentation/widgets/reading_list_card.dart';
import 'package:mirath/features/community/presentation/widgets/researcher_card.dart';
import 'package:mirath/features/home/presentation/widgets/category_items_list.dart';

import '../../../../core/utils/my_sizes.dart';

class CommunitySearchResult extends StatelessWidget {
  const CommunitySearchResult({super.key});

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
                          child: Column(
                            children: [
                              CategoryItemsList(
                                selectedCategory: 'Top',
                                categories: [
                                  "Top",
                                  "Discussions",
                                  "Reading Lists",
                                  "Researchers",
                                ],
                              ),
                              SizedBox(height: MySizes.spaceLg(context)),
                            ],
                          ),
                        ),
                      ),

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
                        delegate: SliverChildBuilderDelegate((context, index) {
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
                        delegate: SliverChildBuilderDelegate((context, index) {
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MySizes.spaceXs(context),
                            ),
                            child: ReadingListCard(),
                          );
                        }, childCount: 3),
                      ),
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

  _CategoryHeaderDelegate({required this.child, required this.context});

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
    return false;
  }
}
