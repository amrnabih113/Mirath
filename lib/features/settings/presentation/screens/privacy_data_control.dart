import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import 'package:mirath/features/settings/presentation/widgets/feed_tiles.dart';

class PrivacyDataControl extends StatefulWidget {
  const PrivacyDataControl({super.key});

  @override
  State<PrivacyDataControl> createState() => _PrivacyDataControlState();
}

class _PrivacyDataControlState extends State<PrivacyDataControl> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().getPrivacySettings();
  }

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
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsSuccess) {
            final currentState =
                state as SettingsSuccess<PrivacySettingsEntitiy>;
            final preference = currentState.data;
            return Padding(
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
                        value: preference.isPrivateAccount,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            isPrivateAccount: value,
                          );
                          context.read<SettingsCubit>().updatePrivacySettings(
                            preference: updatedPreference,
                          );
                        },
                      ),
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    FeedTiles(
                      title: 'Allow profile search',
                      subtitle: 'Appear in users search results',
                      trailing: Switch(
                        value: preference.allowProfileSearch,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            allowProfileSearch: value,
                          );
                          context.read<SettingsCubit>().updatePrivacySettings(
                            preference: updatedPreference,
                          );
                        },
                      ),
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),

                    FeedTiles(
                      title: 'Allow public comments on my discussions',
                      subtitle: 'When off, only people you follow can comment',
                      trailing: Switch(
                        value: preference.allowPublicComments,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            allowPublicComments: value,
                          );
                          context.read<SettingsCubit>().updatePrivacySettings(
                            preference: updatedPreference,
                          );
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
                      title:
                          'Use my reading behavior to improve recommendations',
                      subtitle:
                          'Anonymous usage data sent to recommendation engine',
                      trailing: Switch(
                        value: preference.useReadingBehaviorForRecommendations,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            useReadingBehaviorForRecommendations: value,
                          );
                          context.read<SettingsCubit>().updatePrivacySettings(
                            preference: updatedPreference,
                          );
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
                        context
                            .read<SettingsCubit>()
                            .initiateFullAccountDataExport();
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
                          tilesName: ExportListFormate.values
                              .map(
                                (formate) => switch (formate) {
                                  ExportListFormate.bibtex => 'BibTex',
                                  ExportListFormate.json => 'json',
                                  ExportListFormate.csv => 'CSV',
                                },
                              )
                              .toList(),
                          onselect: (index) {
                            final selectedFormate =
                                ExportListFormate.values[index];
                            context.read<SettingsCubit>().exportReadingLists(
                              formate: selectedFormate,
                            );
                            context.push(RouteNames.verifyIdentity);
                          },
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
                          tilesName: ExportAnnotationsFormate.values
                              .map(
                                (formate) => switch (formate) {
                                  ExportAnnotationsFormate.markdown =>
                                    'Markdown',
                                  ExportAnnotationsFormate.json => 'json',
                                },
                              )
                              .toList(),
                          onselect: (index) {
                            final selectedFormate =
                                ExportAnnotationsFormate.values[index];
                            context
                                .read<SettingsCubit>()
                                .exportAnnotationsAndNotes(
                                  formate: selectedFormate,
                                );
                            context.push(RouteNames.verifyIdentity);
                          },
                        );
                      },
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                  ],
                ),
              ),
            );
          }
          if (state is SettingsFailure) {
            return Center(child: Text(state.errormessage));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
