import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import 'package:mirath/features/settings/presentation/widgets/feed_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/my_research_intrests.dart';

class FeedAiPreferences extends StatefulWidget {
  const FeedAiPreferences({super.key});

  @override
  State<FeedAiPreferences> createState() => _FeedAiPreferencesState();
}

class _FeedAiPreferencesState extends State<FeedAiPreferences> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().getFeedAipreference();
  }

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
              MyResearchIntrests(),
              Divider(color: MyColors.grey, thickness: 2),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is SettingsSuccess<FeedAndAiPreferenceEntity>) {
                    final preference = state.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeedTiles(
                          title: 'Show recommended papers',
                          subtitle: 'AI-matched papers based on your interests',
                          trailing: Switch(
                            value: preference.showRecommendedPapers,
                            onChanged: (value) {
                              final updatedPreference = preference.copyWith(
                                showRecommendedPapers: value,
                              );
                              context
                                  .read<SettingsCubit>()
                                  .updateFeedAipreference(
                                    preference: updatedPreference,
                                  );
                            },
                          ),
                        ),
                        Divider(color: MyColors.grey, thickness: 2),
                        FeedTiles(
                          title: 'Hide already-read papers',
                          subtitle: 'Exclude papers you have opened already',
                          trailing: Switch(
                            value: preference.hideAlreadyReadPapers,
                            onChanged: (value) {
                              final updatedPreference = preference.copyWith(
                                hideAlreadyReadPapers: value,
                              );
                              context
                                  .read<SettingsCubit>()
                                  .updateFeedAipreference(
                                    preference: updatedPreference,
                                  );
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
                            value: preference.saveSearchHistory,
                            onChanged: (value) {
                              final updatedPreference = preference.copyWith(
                                saveSearchHistory: value,
                              );
                              context
                                  .read<SettingsCubit>()
                                  .updateFeedAipreference(
                                    preference: updatedPreference,
                                  );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is SettingsFailure) {
                    return Center(child: Text(state.errormessage));
                  }
                  return SizedBox.shrink();
                },
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
