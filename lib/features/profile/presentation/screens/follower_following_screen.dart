import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/profile/presentation/widgets/follower_following_card.dart';

class FollowerFollowingScreen extends StatelessWidget {
  const FollowerFollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: MyBackIcon(),
          title: Text('username'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: MyColors.primaryShade900,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.separated(
                    padding: const EdgeInsets.all(8),

                    itemCount: 10,
                    itemBuilder: (context, index) => FollowerFollowingCard(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: MySizes.spaceXs(context)),
                  ),
                  // Discussions
                  ListView.separated(
                    padding: const EdgeInsets.all(8),

                    itemCount: 10,
                    itemBuilder: (context, index) => FollowerFollowingCard(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: MySizes.spaceXs(context) * 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
