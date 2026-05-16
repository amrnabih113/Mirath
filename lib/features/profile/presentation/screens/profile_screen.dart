import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/services/sharing_service.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mirath/features/profile/presentation/widgets/user_data.dart';
import 'package:mirath/features/profile/presentation/widgets/user_tabs.dart';
import 'package:mirath/features/users/domain/entities/user.dart';
import 'package:mirath/generated/l10n.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/ui/widgets/state_views.dart';

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
                icon: HugeIcons.strokeRoundedLogout02,
                size: MySizes.iconMedium(context),
                color: Colors.black,
              ),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedShare08,
                    size: MySizes.iconMedium(context),
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (state is ProfileLoadSuccess) {
                      SharingService.shareProfile(state.user);
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings02,
                size: MySizes.iconMedium(context),
                color: Colors.black,
              ),
              onPressed: () {
                context.push(RouteNames.settingsScreen);
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileFailure) {
              final offline = !NetworkManager.instance.currentConnectionStatus;
              return offline
                  ? OfflineStateView(
                      title: 'Offline',
                      message: state.message,
                      actionLabel: 'Retry',
                      onAction: () => context
                          .read<ProfileCubit>()
                          .loadCurrentUser(forceRefresh: true),
                    )
                  : ErrorStateView(
                      title: 'Error',
                      message: state.message,
                      actionLabel: 'Retry',
                      onAction: () => context
                          .read<ProfileCubit>()
                          .loadCurrentUser(forceRefresh: true),
                    );
            }

            User user;

            if (state is ProfileLoadSuccess) {
              user = state.user;
            } else if (state is ProfileUpdateSuccess) {
              user = state.user;
            } else {
              return const SizedBox();
            }

            return RefreshIndicator(
              onRefresh: () => context.read<ProfileCubit>().loadCurrentUser(
                forceRefresh: true,
              ),
              child: Center(
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
                                    user: user,
                                    actionLabel: S.of(context).edit_profile,
                                    color: MyColors.primaryShade50,
                                    labelColor: MyColors.primaryShade900,
                                    onActionTap: () {
                                      context.push(RouteNames.editProfile);
                                    },
                                    onFollowersTap: () {
                                      context.push(
                                        RouteNames.followerFollowingRoute(
                                          user.id,
                                          tab: 0,
                                        ),
                                        extra: {'username': user.username},
                                      );
                                    },
                                    onFollowingTap: () {
                                      context.push(
                                        RouteNames.followerFollowingRoute(
                                          user.id,
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
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(context).sign_out),
        content: Text(S.of(context).are_you_sure_you_want_to_sign_out),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().signOut();
            },
            child: Text(S.of(context).sign_out),
          ),
        ],
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
