import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../users/domain/entities/follows.dart';
import '../../../users/domain/usecases/follow_user_usecase.dart';
import '../../../users/domain/usecases/get_followers_usecase.dart';
import '../../../users/domain/usecases/get_following_usecase.dart';
import '../../../users/domain/usecases/unfollow_user_usecase.dart';
import '../widgets/follower_following_card.dart';

class FollowerFollowingScreen extends StatefulWidget {
  const FollowerFollowingScreen({
    super.key,
    required this.userId,
    this.username,
    this.initialTabIndex = 0,
  });

  final String userId;
  final String? username;
  final int initialTabIndex;

  @override
  State<FollowerFollowingScreen> createState() =>
      _FollowerFollowingScreenState();
}

class _FollowerFollowingScreenState extends State<FollowerFollowingScreen> {
  late final Future<List<Follows>> _followersFuture;
  late final Future<List<Follows>> _followingFuture;

  @override
  void initState() {
    super.initState();
    _followersFuture = _loadFollowers();
    _followingFuture = _loadFollowing();
  }

  Future<List<Follows>> _loadFollowers() async {
    final result = await sl<GetFollowersUsecase>()(widget.userId);
    return result.fold((_) => <Follows>[], (users) => users);
  }

  Future<List<Follows>> _loadFollowing() async {
    final result = await sl<GetFollowingUsecase>()(widget.userId);
    return result.fold((_) => <Follows>[], (users) => users);
  }

  Future<void> _toggleFollow(Follows user) async {
    if (user.isFollowing) {
      await sl<UnfollowUserUsecase>()(user.id);
    } else {
      await sl<FollowUserUsecase>()(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = (widget.username?.isNotEmpty ?? false)
        ? widget.username!
        : S.of(context).username;

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
      child: Scaffold(
        appBar: AppBar(
          leading: MyBackIcon(),
          title: Text(headerTitle),
          centerTitle: true,
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: MyColors.primaryShade900,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: S.of(context).followers),
                        Tab(text: S.of(context).following),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FutureBuilder<List<Follows>>(
                            future: _followersFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final users = snapshot.data ?? const <Follows>[];
                              if (users.isEmpty) {
                                return Center(
                                  child: Text(S.of(context).no_results_found),
                                );
                              }

                              return ListView.separated(
                                padding: const EdgeInsets.all(8),
                                itemCount: users.length,
                                itemBuilder: (context, index) =>
                                    FollowerFollowingCard(
                                      user: users[index],
                                      onUserTap: () {
                                        context.push(
                                          RouteNames.userProfileRoute(
                                            users[index].id,
                                          ),
                                        );
                                      },
                                      onFollowToggle: (_) {
                                        return _toggleFollow(users[index]);
                                      },
                                    ),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: MySizes.spaceXs(context)),
                              );
                            },
                          ),
                          FutureBuilder<List<Follows>>(
                            future: _followingFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final users = snapshot.data ?? const <Follows>[];
                              if (users.isEmpty) {
                                return Center(
                                  child: Text(S.of(context).no_results_found),
                                );
                              }

                              return ListView.separated(
                                padding: const EdgeInsets.all(8),
                                itemCount: users.length,
                                itemBuilder: (context, index) =>
                                    FollowerFollowingCard(
                                      user: users[index],
                                      onUserTap: () {
                                        context.push(
                                          RouteNames.userProfileRoute(
                                            users[index].id,
                                          ),
                                        );
                                      },
                                      onFollowToggle: (_) {
                                        return _toggleFollow(users[index]);
                                      },
                                    ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: MySizes.spaceXs(context) * 0.5,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
