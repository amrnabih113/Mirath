import 'package:flutter/material.dart';
import 'discussion_tab.dart';
import 'reading_lists_tab.dart';
import '../widgets/tab_bar_sliver_delegate.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/search_with_filter.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(
                  bottom: false,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SearchWithFilter(
                              searchController: TextEditingController(),
                            ),
                            SizedBox(height: MySizes.spaceMd(context)),
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: TabBarSliverDelegate(
                          TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: MyColors.primaryShade700,
                            labelStyle: context.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            unselectedLabelStyle: context.titleSmall.copyWith(
                              fontWeight: FontWeight.w400,
                              color: MyColors.textSecondary,
                            ),

                            tabs: const [
                              Tab(text: 'Discussions'),
                              Tab(text: 'Reading Lists'),
                            ],
                          ),
                        ),
                      ),
                    ],
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        const DiscussionTab(),
                        const ReadingListsTab(),
                      ],
                    ),
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
