import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/data/models/all_active_session_model.dart';
import 'package:mirath/features/settings/data/models/feed_and_ai_preference_model.dart';
import 'package:mirath/features/settings/data/models/notification_preferences_model.dart';
import 'package:mirath/features/settings/data/models/privacy_settings_model.dart';
import 'package:mirath/features/settings/data/models/reading_and_appearance_model.dart';
import 'package:mirath/features/settings/data/models/research_interests_model.dart';

abstract class SettingsRemoteDataSource {
  // Account & Security
  Future<String> changeUsername({required String newUsername});
  Future<String> changeEmail({required String newEmail});
  Future<String> confirmEmail({
    required String newEmail,
    required String otpCode,
  });
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
  Future<String> disconnectGoogleAccount();
  Future<List<AllActiveSessionModel>> getAllActiveSession();
  Future<String> revokeAllActiveSessionExceptCurrent();
  // Feed & AI Preferences
  Future<FeedAndAiPreferenceModel> getFeedAndAiPreference();
  Future<FeedAndAiPreferenceModel> updateFeedAndAiPreference({
    required FeedAndAiPreferenceModel preferences,
  });
  Future<List<ResearchInterestsModel>> getResearchInterests();
  Future<List<ResearchInterestsModel>> replaceResearchInterests({
    required List<ResearchInterestsModel> interests,
  });
  //Reading & Appearance
  Future<ReadingAndAppearanceModel> getReadingAndAppearance();
  Future<ReadingAndAppearanceModel> updateThemeandFontDisplayPreferences({
    required ColorMode colorMode,
    required FontSize defaultFontSize,
  });
  Future<ReadingAndAppearanceModel>
  updateReadingListVisibilityandAnnotationColorPalette({
    required Visible defaultReadingListVisibility,
    required List<String> annotationHighlightColors,
  });
  //Notifications
  Future<NotificationPreferencesModel> getNotificationPreferences();
  Future<NotificationPreferencesModel> updateNotificationPreferences({
    required NotificationPreferencesModel preferences,
  });
  //Privacy & Data Control
  Future<PrivacySettingsModel> getPrivacySettings();
  Future<PrivacySettingsModel> updatePrivacySettings({
    required PrivacySettingsModel settings,
  });
  Future<String> initiateFullAccountDataExport();
  Future<void> exportReadingListsAsAFile({required ExportListFormate formate});
  Future<void> exportAnnotationsAndNotes({
    required ExportAnnotationsFormate formate,
  });
  //Account Management
  Future<String> deactivateUserAccount({required String password});
  Future<String> deleteUserAccount({required String password});
}
