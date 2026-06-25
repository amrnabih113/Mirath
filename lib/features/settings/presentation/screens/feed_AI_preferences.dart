import 'package:flutter/material.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import 'package:mirath/features/settings/presentation/widgets/feed_tiles.dart';

class FeedAiPreferences extends StatefulWidget {
  const FeedAiPreferences({super.key});

  @override
  State<FeedAiPreferences> createState() => _FeedAiPreferencesState();
}

class _FeedAiPreferencesState extends State<FeedAiPreferences> {
  final List<String> _selected = [
    'AI',
    'Flutter',
    'Dart',
    'Mobile Development',
  ];
  void _toggleInterest(String name) {
    setState(() {
      _selected.contains(name) ? _selected.remove(name) : _selected.add(name);
    });
  }

  bool _enable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Feed & AI Preferences',
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
                'Interests & Feed Control',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Control how Mirath learns your interests and surfaces papers',
                style: context.bodyLarge.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My research interests',
                      style: context.labelLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Can be different from interests on the profiles'),

                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ..._selected.map(
                          (e) => GestureDetector(
                            onTap: () => _toggleInterest(e),
                            child: TagChip(label: e, hasIcon: true),
                          ),
                        ),

                        TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            backgroundColor: MyColors.primaryShade200,
                            minimumSize: const Size(0, 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: const BorderSide(color: Colors.black),
                          ),
                          icon: const Icon(
                            Icons.add,
                            color: MyColors.black,
                            size: 25,
                          ),
                          label: Text(
                            'Add interest',
                            style: context.labelLarge.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MyColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(color: MyColors.grey, thickness: 2),
              FeedTiles(
                title: 'Show recommended papers',
                subtitle: 'AI-matched papers based on your interests',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.grey, thickness: 2),
              FeedTiles(
                title: 'Hide already-read papers',
                subtitle: 'Exclude papers you have opened already',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.grey, thickness: 2),
              Text(
                'Search History',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              FeedTiles(
                title: 'Save search history',
                subtitle: 'Used to improve recommendations',
                trailing: Switch(
                  value: _enable,
                  onChanged: (value) {
                    setState(() {
                      _enable = value;
                    });
                  },
                ),
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                title: 'Clear search history',
                subtitle: 'Removes all past searches from your account',
                onTap: () {
                  showMyDialog(
                    context,
                    onConfirm: () {},
                    title: 'Clear history?',
                    content:
                        'This will delete all past searches from your account. You won’t be able to get them back.',
                    fTextBtn: 'Clear',
                    sTextBtn: 'Cancel',
                  );
                },
                btnName: 'Clear history',
                textColor: MyColors.error,
              ),
              Divider(color: MyColors.grey, thickness: 2),
            ],
          ),
        ),
      ),
    );
  }
}
