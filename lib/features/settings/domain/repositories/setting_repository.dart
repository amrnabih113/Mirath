import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/domain/entities/all_active_session_entity.dart';
import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';
import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';

abstract class SettingsRepository {
  // Account & Security
  Future<Either<Failure, void>> changeUsername({required String newUsername});
  Future<Either<Failure, void>> changeEmail({required String newEmail});
  Future<Either<Failure, void>> confirmEmail({
    required String newEmail,
    required String otpCode,
  });
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
  Future<Either<Failure, void>> disconnectGoogleAccount();
  Future<Either<Failure, List<AllActiveSessionEntity>>> getAllActiveSession();
  Future<Either<Failure, void>> revokeAllActiveSessionExceptCurrent();
  // Feed & AI Preferences
  Future<Either<Failure, FeedAndAiPreferenceEntity>> getFeedAndAiPreference();
  Future<Either<Failure, FeedAndAiPreferenceEntity>> updateFeedAndAiPreference({
    required FeedAndAiPreferenceEntity preferences,
  });
  Future<Either<Failure, List<ResearchInterestsEntitiy>>>
  getResearchInterests();
  Future<Either<Failure, List<ResearchInterestsEntitiy>>>
  replaceResearchInterests({required List<ResearchInterestsEntitiy> interests});
  //Reading & Appearance
  Future<Either<Failure, ReadingAndAppearanceEntitiy>>
  getReadingAndAppearance();
  Future<Either<Failure, ReadingAndAppearanceEntitiy>>
  updatethemeAndDisplayPreferences({
    required ColorMode colorMode,
    required FontSize defaultFontSize,
  });
  Future<Either<Failure, ReadingAndAppearanceEntitiy>>
  updateReadingListVisibilityandAnnotationColorPalette({
    required Visible defaultReadingListVisibility,
    required List<String> annotationHighlightColors,
  });
  //Notifications
  Future<Either<Failure, NotificationPreferencesEntity>>
  getNotificationPreferences();
  Future<Either<Failure, NotificationPreferencesEntity>>
  updateNotificationPreferences({
    required NotificationPreferencesEntity preferences,
  });
  //Privacy & Data Control
  Future<Either<Failure, PrivacySettingsEntitiy>> getPrivacySettings();
  Future<Either<Failure, PrivacySettingsEntitiy>> updatePrivacySettings({
    required PrivacySettingsEntitiy settings,
  });
  Future<Either<Failure, void>> initiateFullAccountDataExport();
  Future<Either<Failure, void>> exportReadingListsAsAFile({
    required ExportListFormate formate,
  });
  Future<Either<Failure, void>> exportAnnotationsAndNotes({
    required ExportAnnotationsFormate formate,
  });
  //Account Management
  Future<Either<Failure, void>> deactivateUserAccount({
    required String password,
  });
  Future<Either<Failure, void>> deleteUserAccount({required String password});
}
