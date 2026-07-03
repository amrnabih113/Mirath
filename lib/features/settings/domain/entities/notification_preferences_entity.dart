import 'package:equatable/equatable.dart';

class NotificationPreferencesEntity extends Equatable {
  final bool newPapersInField;
  final bool readingListActivity;
  final bool newFollowers;
  final bool discussionReplies;
  final bool commentMentions;
  final bool votesOnContent;
  final bool securityAlerts;

  const NotificationPreferencesEntity({
    required this.newPapersInField,
    required this.readingListActivity,
    required this.newFollowers,
    required this.discussionReplies,
    required this.votesOnContent,
    required this.securityAlerts,
    required this.commentMentions,
  });
  NotificationPreferencesEntity copyWith({
    bool? newPapersInField,
    bool? readingListActivity,
    bool? newFollowers,
    bool? discussionReplies,
    bool? commentMentions,
    bool? votesOnContent,
    bool? securityAlerts,
  }) {
    return NotificationPreferencesEntity(
      newPapersInField: newPapersInField ?? this.newPapersInField,
      readingListActivity: readingListActivity ?? this.readingListActivity,
      newFollowers: newFollowers ?? this.newFollowers,
      discussionReplies: discussionReplies ?? this.discussionReplies,
      commentMentions: commentMentions ?? this.commentMentions,
      votesOnContent: votesOnContent ?? this.votesOnContent,
      securityAlerts: securityAlerts ?? this.securityAlerts,
    );
  }

  @override
  List<Object?> get props => [
    newPapersInField,
    readingListActivity,
    newFollowers,
    discussionReplies,
    commentMentions,
    votesOnContent,
    securityAlerts,
  ];
}
