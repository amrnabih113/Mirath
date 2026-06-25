import 'package:flutter/material.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import 'package:mirath/features/settings/presentation/widgets/feed_tiles.dart';

class PrivacyDataControl extends StatefulWidget {
  const PrivacyDataControl({super.key});

  @override
  State<PrivacyDataControl> createState() => _PrivacyDataControlState();
}

class _PrivacyDataControlState extends State<PrivacyDataControl> {
  bool privateAccount = true;
  bool allowProfileSearch = true;
  bool allowComments = true;
  bool improveRecommendations = true;
  bool allowReading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Privacy & Data Control',
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
                'Profile Visibility & Interactions',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              FeedTiles(
                title: 'Private account',
                subtitle:
                    'When your account is public, your profile and posts can be seen by anyone.',
                trailing: Switch(
                  value: privateAccount,
                  onChanged: (value) {
                    setState(() {
                      privateAccount = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              FeedTiles(
                title: 'Allow profile search',
                subtitle: 'Appear in users search results',
                trailing: Switch(
                  value: allowProfileSearch,
                  onChanged: (value) {
                    setState(() {
                      allowProfileSearch = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),

              FeedTiles(
                title: 'Allow public comments on my discussions',
                subtitle: 'When off, only people you follow can comment',
                trailing: Switch(
                  value: allowComments,
                  onChanged: (value) {
                    setState(() {
                      allowComments = value;
                    });
                  },
                ),
              ),

              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Data & Personalization',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              FeedTiles(
                title: 'Use my reading behavior to improve recommendations',
                subtitle: 'Anonymous usage data sent to recommendation engine',
                trailing: Switch(
                  value: allowReading,
                  onChanged: (value) {
                    setState(() {
                      allowReading = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Data Export',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                title: 'Download all my data',
                subtitle:
                    'Request ZIP of profile, lists, annotations, discussions, and saved papers',
                btnName: 'Request',
                onTap: () {
                  dataArchiveDialog(context);
                },
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Export reading lists',
                subtitle: 'Export as BibTex, JSON, or CSV',
                btnName: 'Export',
                onTap: () {
                  showButtonDialog(
                    context,
                    title: 'Export your reading lists as',
                    tilesName: ['BibTex', 'JSON', 'CSV'],
                  );
                },
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Export annotations & notes',
                subtitle:
                    'Download all highlights and notes as Markdown or JSON',
                btnName: 'Export',
                onTap: () {
                  showButtonDialog(
                    context,
                    title: 'Export your annotations & notes as',
                    tilesName: ['Markdown', 'JSON'],
                  );
                },
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}
