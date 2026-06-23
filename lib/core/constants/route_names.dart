/// Central place for all route names and paths in the application
/// Using constants prevents typos and makes refactoring easier
class RouteNames {
  RouteNames._();

  // ===================== SPLASH & AUTH =====================
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String verifyAccount = '/verify-account';
  static const String forgetPassword = '/forget-password';
  static const String verifyResetOtp = '/verify-reset-otp';
  static const String resetPassword = '/reset-password';
  static const String updatePassword = '/update-password';

  // ===================== PROFILE SETUP =====================
  static const String setupProfile = '/set-up-profile';
  static const String interests = '/interests';
  static const String editProfile = '/edit-profile';
  static const String editInterests = '/edit-interests';
  static const String settingsScreen = '/settings';
  // ===================== SETTINGS =====================
  static const String accountSettings = '/account-settings';
  static const String accountSecurity = '/account-security';
  static const String feedAiPreferences = '/feed-ai-preferences';
  static const String readingAppearance = '/reading-appearance';
  static const String notifications = '/notifications';
  static const String privacyDataControl = '/privacy-data-control';
  static const String supportLegal = '/support-legal';
  static const String accountManagement = '/account-management';
  static const String changeEmail = '/change-email';
  static const String changeUsername = '/change-username';

  // ===================== MAIN LAYOUT ROUTES =====================
  static const String home = '/home';
  static const String community = '/community';
  static const String library = '/library';
  static const String profile = '/profile';

  // ===================== SEARCH & DISCOVERY =====================
  static const String search = '/search';
  static const String homeSearchResults = '/home-search-results';
  static const String communitySearchResults = '/community-search-results';
  static const String recentlyPublished = '/recently-published';

  // ===================== PAPERS & READING =====================
  /// Paper details screen - requires paperId in path: /papers/:paperId
  static const String paperDetails = '/papers/:paperId';

  /// Paper reading/annotation screen - requires paperId: /papers/:paperId/read
  static const String paperReading = '/papers/:paperId/read';

  /// Paper discussions - requires paperId: /papers/:paperId/discussions
  static const String paperDiscussions = '/papers/:paperId/discussions';

  // ===================== DISCUSSIONS =====================
  static const String community_base = '/community';

  /// Discussion details screen - requires discussionId in path: /discussions/:discussionId
  static const String discussionDetails = '/discussions/:discussionId';
  static const String addDiscussion = '/add-discussion';

  // ===================== READING LISTS =====================
  static const String readingLists = '/reading-lists';

  /// Reading list details - requires readingListId in path: /reading-lists/:readingListId
  static const String readingListDetails = '/reading-lists/:readingListId';
  static const String readingHistory = '/reading-history';
  static const String readLater = '/read-later';

  // ===================== USER PROFILES =====================
  /// Other user profile - requires userId in path: /users/:userId
  static const String userProfile = '/users/:userId';

  /// Follower/Following screen - requires userId: /users/:userId/followers?tab=0&1
  static const String followerFollowing = '/users/:userId/followers';

  // ===================== OTHER =====================
  static const String projects = '/projects';
  static const String otherUserReadingList = '/other-user-reading-list';
  static const String chatbot = '/chatbot';

  // ===================== HELPER METHODS =====================
  /// Generate paper details route with paperId
  static String paperDetailsRoute(String paperId) => '/papers/$paperId';

  /// Generate paper reading route with paperId
  static String paperReadingRoute(String paperId) => '/papers/$paperId/read';

  /// Generate paper discussions route with paperId
  static String paperDiscussionsRoute(String paperId) =>
      '/papers/$paperId/discussions';

  /// Generate discussion details route with discussionId
  static String discussionDetailsRoute(String discussionId) =>
      '/discussions/$discussionId';

  /// Generate reading list details route with readingListId
  static String readingListDetailsRoute(String readingListId) =>
      '/reading-lists/$readingListId';

  /// Generate user profile route with userId
  static String userProfileRoute(String userId) => '/users/$userId';

  /// Generate follower/following route with userId and optional tab
  static String followerFollowingRoute(String userId, {int tab = 0}) =>
      '/users/$userId/followers?tab=$tab';
}
