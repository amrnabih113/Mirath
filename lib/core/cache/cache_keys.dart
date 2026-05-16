class CacheKeys {
  static const String homeRecentPrefix = 'home:recent';
  static const String homeRecommendationsPrefix = 'home:recommendations';
  static const String homeCategoriesPrefix = 'home:categories';
  static const String discussionsPrefix = 'community:discussions';
  static const String readingListsPrefix = 'reading_lists:lists';
  static const String profilePrefix = 'profile:user';

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
}
