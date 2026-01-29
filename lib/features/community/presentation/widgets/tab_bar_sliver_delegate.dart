import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';

class TabBarSliverDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabBarSliverDelegate(this.tabBar);

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
    return Container(
      color: MyColors.light,
      child: Material(color: Colors.transparent, child: tabBar),
    );
  }

  @override
  bool shouldRebuild(covariant TabBarSliverDelegate oldDelegate) => false;
}
