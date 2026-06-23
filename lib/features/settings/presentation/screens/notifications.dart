import 'package:flutter/material.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/feed_tiles.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _enable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Notifications',
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Research Alerts',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              FeedTiles(
                title: 'New papers in my field',
                subtitle:
                    'Weekly digest of new publications matching your interests',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              FeedTiles(
                title: 'Reading list activity',
                subtitle: 'When someone saves your public reading lists',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Social Interactions',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              FeedTiles(
                title: 'New followers',
                subtitle: 'When someone follows you',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              FeedTiles(
                title: 'Discussion replies',
                subtitle: 'When someone replies to your discussions',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              FeedTiles(
                title: 'Comment mentions',
                subtitle: 'When someone mentions you in comments',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              FeedTiles(
                title: 'Votes on your content',
                subtitle: 'Upvotes on your discussions and comments',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Security alerts',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              FeedTiles(
                title: 'Security alerts',
                subtitle: 'New logins and suspicious activity',
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),

                  decoration: BoxDecoration(
                    color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('Always on', style: context.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
