class MyConstants {
  MyConstants._();

  // app name
  static const String appName = "Mirath";

  static const String googleServerClientId =
      "551081167484-bruuovdj7oal5gsej29vbja5803a3520.apps.googleusercontent.com";

  // storage keys
  static const String onboardingKey = 'has_seen_onboarding';
  static const String profileSetupKey = 'has_setup_profile';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String emailKey = 'user_email';
  static const String setupStatusKey = 'setup_status';
  static const String userDataKey = 'user_data';
  static const String annotationTranslationLanguageKey =
      'annotation_translation_language';

  // base url
  // Use 10.0.2.2 for Android emulator (maps to host machine's localhost)
  // Use your computer's IP (e.g., 192.168.x.x) for real devices
  // Use 127.0.0.1 for iOS simulator or web
  static const String baseUrl = "http://192.168.1.5:3000/";
  // static const String baseUrl = "http://10.0.2.2:3000/";

  // Endpoints
  // ***Auth endpoints***
  // post
  static const String signUp = "api/v1/auth/signup";
  // post
  static const String verifyEmail = "api/v1/auth/verify-email";
  // post
  static const String resendVerification = "api/v1/auth/resend-verification";
  // post
  static const String google = "api/v1/auth/google";
  // post
  static const String login = "api/v1/auth/login";
  // post
  static const String logout = "api/v1/auth/logout";
  // post
  static const String forgetPassword = "api/v1/auth/forget-password";
  // post
  static const String verifyResetPasswordOTP = "api/v1/auth/verify-reset-code";
  // post
  static const String resetPassword = "api/v1/auth/reset-password";
  // post
  static const String refreshToken = "api/v1/auth/refresh";
  // post
  static const String isVerified = "api/v1/auth/is-verified";
  // get
  static const String checkSetup = "api/v1/auth/check-setup";

  // ***User endpoints***
  // post
  static const String setupProfile = "api/v1/users/profile/setup";
  // get
  static const String getMe = "api/v1/users/me";
  // get
  static const String getUserProfileHeader = "api/v1/users/{id}/profile";
  // post
  static const String followUser = "api/v1/users/{id}/follow";
  // delete
  static const String unfollowUser = "api/v1/users/{id}/follow";

  // ***Interests endpoints***
  // get
  static const String getAllInterests = "api/v1/interests";
  // get
  static const String getInterestById = "api/v1/interests/{id}";

  // ***Home endpoints***
  // get
  static const String getRecent = "api/v1/feed/recent";
  // get
  static const String getRecommended = "api/v1/feed/recommendations";

  // ***Discussions endpoints***
  // post
  static const String createDiscussion = "api/v1/discussions";
  // get
  static const String getAllDiscussions = "api/v1/discussions";
  // get
  static const String getDiscussionById = "api/v1/discussions/{id}";
  // delete
  static const String deleteDiscussion = "api/v1/discussions/{id}";
  // post
  static const String voteOnDiscussion = "api/v1/discussions/{id}/vote";
  // delete
  static const String deleteDiscussionVote = "api/v1/discussions/{id}/vote";
  // post
  static const String createComment = "api/v1/discussions/{id}/comments";
  // get
  static const String getDiscussionComments =
      "api/v1/discussions/{id}/comments";

  // ***Comments endpoints***
  // post
  static const String voteOnComment = "api/v1/comments/{id}/vote";
  // delete
  static const String deleteCommentVote = "api/v1/comments/{id}/vote";

  // ***Reading Lists endpoints***
  // get
  static const String getReadingLists = "api/v1/reading-lists";
  static const String getMyReadingLists = "api/v1/reading-lists";
  // get
  static const String getAllReadingLists = "api/v1/reading-lists/all";
  // post
  static const String createReadingList = "api/v1/reading-lists";
  // get
  static const String getReadingListById = "api/v1/reading-lists/{id}";
  // patch
  static const String updateReadingList = "api/v1/reading-lists/{id}";
  // delete
  static const String deleteReadingList = "api/v1/reading-lists/{id}";
  // post
  static const String addPaperToList = "api/v1/reading-lists/{id}/papers";
  // delete
  static const String removePaperFromList =
      "api/v1/reading-lists/{id}/papers/{paperId}";
  // post
  static const String saveReadingList = "api/v1/reading-lists/{id}/save";
  // delete
  static const String unsaveReadingList = "api/v1/reading-lists/{id}/save";

  // ***Papers endpoints***
  // post
  static const String savePaper = "api/v1/papers/{id}/save";
  // delete
  static const String unsavePaper = "api/v1/papers/{id}/save";
  // get
  static const String getPaperById = "api/v1/papers/{id}";

  // ***Paper Annotations endpoints***
  // post / get
  static const String paperHighlights = "api/v1/papers/{id}/highlights";
  // patch / delete
  static const String paperHighlightById =
      "api/v1/papers/{id}/highlights/{highlightId}";
  // post / patch / delete
  static const String paperHighlightNote =
      "api/v1/papers/{id}/highlights/{highlightId}/note";
  // get
  static const String paperHighlightsNotes =
      "api/v1/papers/{id}/highlights/notes";

  // ***search endpoints***
  static const String searchPapers = "api/v1/papers/search";
  static const String searchHistory = "api/v1/search/history";
  static const String deleteSearchHistoryById = "api/v1/search/history/{id}";
}
