import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/profile/presentation/widgets/profile_reading_list_card.dart';

class UserTabs extends StatelessWidget {
  const UserTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // Reading Lists
        ListView.separated(
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: 10,
          itemBuilder: (context, index) => ProfileReadingListCard(
            onTap: () {
              context.push('/paper-screen');
            },
          ),
          separatorBuilder: (context, index) =>
              SizedBox(height: MySizes.spaceXs(context)),
        ),
        // Discussions
        ListView.separated(
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ProfileReadingListCard();
            //   return  DiscussionCard(
            //   discussion:
            // );
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: MySizes.spaceXs(context) * 0.5),
        ),
      ],
    );
  }
}
