import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card.dart';

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
          itemBuilder: (context, index) => PaperCard(onTap: () {}),

          // ProfileReadingListCard(
          //   onTap: () {
          //     context.push('/paper-screen');
          //   },
          // ),
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
            return PaperCard(onTap: () {});
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
