import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/feed_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/special_text.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().getNotificationPreferences();
  }

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
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsSuccess<NotificationPreferencesEntity>) {
            final preference = state.data;
            return Padding(
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
                        value: preference.newPapersInField,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            newPapersInField: value,
                          );
                          context
                              .read<SettingsCubit>()
                              .updateNotificationPreferences(
                                preference: updatedPreference,
                              );
                        },
                      ),
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    FeedTiles(
                      title: 'Reading list activity',
                      subtitle: 'When someone saves your public reading lists',
                      trailing: Switch(
                        value: preference.readingListActivity,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            readingListActivity: value,
                          );
                          context
                              .read<SettingsCubit>()
                              .updateNotificationPreferences(
                                preference: updatedPreference,
                              );
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
                        value: preference.newFollowers,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            newFollowers: value,
                          );
                          context
                              .read<SettingsCubit>()
                              .updateNotificationPreferences(
                                preference: updatedPreference,
                              );
                        },
                      ),
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    FeedTiles(
                      title: 'Discussion replies',
                      subtitle: 'When someone replies to your discussions',
                      trailing: Switch(
                        value: preference.discussionReplies,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            discussionReplies: value,
                          );
                          context
                              .read<SettingsCubit>()
                              .updateNotificationPreferences(
                                preference: updatedPreference,
                              );
                        },
                      ),
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    FeedTiles(
                      title: 'Comment mentions',
                      subtitle: 'When someone mentions you in comments',
                      trailing: Switch(
                        value: preference.commentMentions,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            commentMentions: value,
                          );
                          context
                              .read<SettingsCubit>()
                              .updateNotificationPreferences(
                                preference: updatedPreference,
                              );
                        },
                      ),
                    ),
                    Divider(color: MyColors.darkGrey, thickness: 1),
                    FeedTiles(
                      title: 'Votes on your content',
                      subtitle: 'Upvotes on your discussions and comments',
                      trailing: Switch(
                        value: preference.votesOnContent,
                        onChanged: (value) {
                          final updatedPreference = preference.copyWith(
                            votesOnContent: value,
                          );
                          context
                              .read<SettingsCubit>()
                              .updateNotificationPreferences(
                                preference: updatedPreference,
                              );
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
                      trailing: SpecialText(
                        addText: preference.securityAlerts
                            ? 'Always on'
                            : 'Disabled',
                        backColor: preference.securityAlerts
                            ? Color(0xffFFC966)
                            : Colors.grey,
                      ),
                    ),
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
