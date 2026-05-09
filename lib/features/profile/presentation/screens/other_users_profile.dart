import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/services/sharing_service.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/profile/presentation/widgets/user_data.dart';
import 'package:mirath/features/profile/presentation/widgets/user_tabs.dart';
import 'package:mirath/features/users/presentation/cubit/profile_header_cubit.dart';
import 'package:mirath/features/users/presentation/cubit/profile_header_state.dart';
import 'package:mirath/generated/l10n.dart';

class OtherUsersProfile extends StatelessWidget {
  const OtherUsersProfile({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<ProfileHeaderCubit, ProfileHeaderState>(
              builder: (context, state) {
                return IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMoreHorizontal,
                    size: MySizes.iconMedium(context),
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (state is ProfileHeaderLoaded) {
                      _showUserProfileMenu(context, state.user);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: BlocBuilder<ProfileHeaderCubit, ProfileHeaderState>(
                  builder: (context, state) {
                    if (state is ProfileHeaderInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ProfileHeaderLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ProfileHeaderError) {
                      return Center(child: Text(state.message));
                    }

                    final loaded = state as ProfileHeaderLoaded;
                    final user = loaded.user;

                    return NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverToBoxAdapter(
                                child: UserData(
                                  user: user,
                                  actionLabel: user.isFollowed == true
                                      ? S.of(context).following
                                      : S.of(context).follow,
                                  color: MyColors.primaryShade900,
                                  labelColor: MyColors.primaryShade50,
                                  onActionTap: () {
                                    if (loaded.isFollowLoading) return;
                                    if (user.isFollowed == true) {
                                      context
                                          .read<ProfileHeaderCubit>()
                                          .unfollowUser(user.id);
                                    } else {
                                      context
                                          .read<ProfileHeaderCubit>()
                                          .followUser(user.id);
                                    }
                                  },
                                  onFollowersTap: () {
                                    context.push(
                                      RouteNames.followerFollowingRoute(
                                        userId,
                                        tab: 0,
                                      ),
                                      extra: {'username': user.username},
                                    );
                                  },
                                  onFollowingTap: () {
                                    context.push(
                                      RouteNames.followerFollowingRoute(
                                        userId,
                                        tab: 1,
                                      ),
                                      extra: {'username': user.username},
                                    );
                                  },
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
                      body: UserTabs(userId: user.id),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showUserProfileMenu(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedShare08),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                SharingService.shareProfile(user);
              },
            ),
          ],
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
