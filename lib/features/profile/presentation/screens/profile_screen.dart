import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/profile/presentation/widgets/user_data.dart';
import 'package:mirath/features/profile/presentation/widgets/user_tabs.dart';
import 'package:mirath/generated/l10n.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).profile),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedLinkForward,
                size: MySizes.iconMedium(context),
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings02,
                size: MySizes.iconMedium(context),
                color: Colors.black,
              ),
              onPressed: () {
                context.push('/setting_screen');
              },
            ),
          ],
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: UserData(
                              label: S.of(context).edit_profile,
                              color: MyColors.primaryShade50,
                              labelColor: MyColors.primaryShade900,
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _TabBarDelegate(
                              TabBar(
                                indicatorColor: MyColors.primaryShade900,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: S.of(context).reading_lists),
                                  Tab(text: S.of(context).discussions),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                  body: UserTabs(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
