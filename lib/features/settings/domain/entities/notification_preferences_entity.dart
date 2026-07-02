class NotificationPreferencesEntity {
  final bool newPapersInField;
  final bool readingListActivity;
  final bool newFollowers;
  final bool discussionReplies;
  final bool commentMentions;
  final bool votesOnContent;
  final bool securityAlerts;

  NotificationPreferencesEntity({
    required this.newPapersInField,
    required this.readingListActivity,
    required this.newFollowers,
    required this.discussionReplies,
    required this.votesOnContent,
    required this.securityAlerts,
    required this.commentMentions,
  });
}
