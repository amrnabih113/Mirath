import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';

class NotificationPreferencesModel extends NotificationPreferencesEntity {
  const NotificationPreferencesModel({
    required super.newPapersInField,
    required super.readingListActivity,
    required super.newFollowers,
    required super.discussionReplies,
    required super.votesOnContent,
    required super.securityAlerts,
    required super.commentMentions,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final research = data['research'] as Map<String, dynamic>? ?? {};
    final social = data['social'] as Map<String, dynamic>? ?? {};
    final system = data['system'] as Map<String, dynamic>? ?? {};

    return NotificationPreferencesModel(
      newPapersInField: research['newPapersInField'] ?? false,
      readingListActivity: research['readingListActivity'] ?? false,
      newFollowers: social['newFollowers'] ?? false,
      discussionReplies: social['discussionReplies'] ?? false,
      commentMentions: social['commentMentions'] ?? false,
      votesOnContent: social['votesOnContent'] ?? false,
      securityAlerts: system['securityAlerts'] ?? false,
    );
  }
  factory NotificationPreferencesModel.fromEntity(
    NotificationPreferencesEntity entity,
  ) {
    return NotificationPreferencesModel(
      newPapersInField: entity.newPapersInField,
      readingListActivity: entity.readingListActivity,
      newFollowers: entity.newFollowers,
      discussionReplies: entity.discussionReplies,
      commentMentions: entity.commentMentions,
      votesOnContent: entity.votesOnContent,
      securityAlerts: entity.securityAlerts,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'newPapersInField': newPapersInField,
      'readingListActivity': readingListActivity,
      'newFollowers': newFollowers,
      'discussionReplies': discussionReplies,
      'commentMentions': commentMentions,
      'votesOnContent': votesOnContent,
    };
  }
}
