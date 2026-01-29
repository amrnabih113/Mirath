import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/community/presentation/widgets/discussion_card.dart';

class DiscussionTab extends StatelessWidget {
  const DiscussionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: MySizes.spaceMd(context),
        bottom:
            kBottomNavigationBarHeight +
            MySizes.spaceMd(context) +
            MediaQuery.of(context).padding.bottom,
      ),
      separatorBuilder: (context, index) =>
          SizedBox(height: MySizes.spaceMd(context)),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          context.push('/disscussion-details');
        },
        child: const DiscussionCard(),
      ),
      itemCount: 10,
    );
  }
}
