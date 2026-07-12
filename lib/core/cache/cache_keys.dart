class CacheKeys {
  static const String homeRecentPrefix = 'home:recent';
  static const String homeRecommendationsPrefix = 'home:recommendations';
  static const String homeCategoriesPrefix = 'home:categories';
  static const String discussionsPrefix = 'community:discussions';
  static const String readingListsPrefix = 'reading_lists:lists';
  static const String profilePrefix = 'profile:user';
  static const String settingsPrefix = 'settings_';

  static String homeRecent({String? category, int page = 1, int limit = 10}) {
    return '$homeRecentPrefix|category=${category ?? 'all'}|page=$page|limit=$limit';
  }

  static String homeRecommendations({int page = 1, int limit = 5}) {
    return '$homeRecommendationsPrefix|page=$page|limit=$limit';
  }

  static String homeCategories({int page = 1, int limit = 20}) {
    return '$homeCategoriesPrefix|page=$page|limit=$limit';
  }

  static String discussions({
    String sort = 'new',
    String? topicId,
    String? authorId,
    int page = 1,
    int limit = 10,
  }) {
    return '$discussionsPrefix|sort=$sort|topic=${topicId ?? 'all'}|author=${authorId ?? 'all'}|page=$page|limit=$limit';
  }

  static String discussionById(String discussionId) {
    return '$discussionsPrefix|id=$discussionId';
  }

  static String readingLists({
    String? ownerId,
    bool saved = false,
    bool all = false,
    int page = 1,
    int limit = 20,
  }) {
    return '$readingListsPrefix|owner=${ownerId ?? 'all'}|saved=$saved|all=$all|page=$page|limit=$limit';
  }

  static String readingListById(String readingListId) {
    return '$readingListsPrefix|id=$readingListId';
  }

  static String profile(String userId) {
    return '$profilePrefix|id=$userId';
  }

  // Library stats cache key
  static String libraryStats() {
    return 'library:stats';
  }

  // Settings cache keys
  static const kFeedAndAi = '${settingsPrefix}settings_feed_and_ai_preference';
  static const kNotificationPrefs =
      '${settingsPrefix}settings_notification_preferences';
  static const kPrivacy = '${settingsPrefix}settings_privacy_settings';
  static const kReadingAppearance =
      '${settingsPrefix}settings_reading_and_appearance';
  static const kResearchInterests =
      '${settingsPrefix}settings_research_interests';

  // Messaging cache keys
  static const String messagesPrefix = 'messages:conversation';

  static String messages(String conversationId) {
    return '$messagesPrefix|id=$conversationId';
  }

  static String messageById(String messageId) {
    return '$messagesPrefix|messageId=$messageId';
  }

  // Paper
  static String paperById(String paperId) {
    return 'paper:id=$paperId';
  }

  // Discussion comments
  static const String commentsPrefix = 'community:comments';

  static String comments(String discussionId) {
    return '$commentsPrefix|discussionId=$discussionId';
  }

  static String commentById(String commentId) {
    return '$commentsPrefix|commentId=$commentId';
  }
}
