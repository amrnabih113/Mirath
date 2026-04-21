import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/profile/presentation/widgets/reading_list_card.dart';

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
          itemBuilder: (context, index) => const ReadingListCard(),
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
            return ReadingListCard();
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
