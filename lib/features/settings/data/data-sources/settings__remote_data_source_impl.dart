import 'package:mirath/core/network/dio_client.dart';
import 'package:mirath/core/utils/my_constants.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/data/data-sources/settings_remote_data_source.dart';
import 'package:mirath/features/settings/data/models/all_active_session_model.dart';
import 'package:mirath/features/settings/data/models/feed_and_ai_preference_model.dart';
import 'package:mirath/features/settings/data/models/notification_preferences_model.dart';
import 'package:mirath/features/settings/data/models/privacy_settings_model.dart';
import 'package:mirath/features/settings/data/models/reading_and_appearance_model.dart';
import 'package:mirath/features/settings/data/models/research_interests_model.dart';

class SettingsRemoteDataSourceImpl extends SettingsRemoteDataSource {
  final DioClient _dioClient;

  SettingsRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<String> changeEmail({required String newEmail}) async {
    final response = await _dioClient.post(
      MyConstants.changeEmail,
      data: {'newEmail': newEmail},
    );
    return response.data['message'];
  }

  @override
  Future<String> confirmEmail({
    required String newEmail,
    required String otpCode,
  }) async {
    final response = await _dioClient.post(
      MyConstants.confirmEmail,
      data: {'newEmail': newEmail, 'otp': otpCode},
    );
    return response.data['message'];
  }

  @override
  Future<String> changeUsername({required String newUsername}) async {
    final response = await _dioClient.patch(
      MyConstants.changeUsername,
      data: {'newUsername': newUsername},
    );
    return response.data['message'];
  }

  @override
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await _dioClient.patch(
      MyConstants.updateAccountPassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );
    return response.data['message'];
  }

  @override
  Future<String> deactivateUserAccount({required String password}) async {
    final response = await _dioClient.post(
      MyConstants.deactivateUserAccount,
      data: {'password': password},
    );
    return response.data['message'];
  }

  @override
  Future<String> deleteUserAccount({required String password}) async {
    final response = await _dioClient.post(
      MyConstants.deleteUserAccount,
      data: {'password': password},
    );
    return response.data['message'];
  }

  @override
  Future<String> disconnectGoogleAccount() async {
    final response = await _dioClient.delete(
      MyConstants.disconnectLinkedGoogleAccount,
    );
    return response.data['message'];
  }

  @override
  Future<void> exportAnnotationsAndNotes({
    required ExportAnnotationsFormate formate,
  }) async {
    await _dioClient.get(
      MyConstants.exportAnnotationsAndNotes,
      queryParameters: {'format': formate.name},
    );
  }

  @override
  Future<void> exportReadingListsAsAFile({
    required ExportListFormate formate,
  }) async {
    await _dioClient.get(
      MyConstants.exportReadingListsAsAFile,
      queryParameters: {'format': formate.name},
    );
  }

  @override
  Future<List<AllActiveSessionModel>> getAllActiveSession() async {
    final response = await _dioClient.get(MyConstants.retriveAllActiveSessions);
    final List<dynamic> sessions = response.data['data'];
    return sessions.map((e) => AllActiveSessionModel.fromJson(e)).toList();
  }

  @override
  Future<FeedAndAiPreferenceModel> getFeedAndAiPreference() async {
    final response = await _dioClient.get(
      MyConstants.retrieveFeedAndAiPreferences,
    );
    return FeedAndAiPreferenceModel.fromJson(response.data);
  }

  @override
  Future<NotificationPreferencesModel> getNotificationPreferences() async {
    final response = await _dioClient.get(
      MyConstants.retrieveNotificationPreferences,
    );

    return NotificationPreferencesModel.fromJson(response.data);
  }

  @override
  Future<PrivacySettingsModel> getPrivacySettings() async {
    final response = await _dioClient.get(MyConstants.retrievePrivacySettings);
    return PrivacySettingsModel.fromJson(response.data);
  }

  @override
  Future<ReadingAndAppearanceModel> getReadingAndAppearance() async {
    final response = await _dioClient.get(
      MyConstants.reteieveReadingAndAppearance,
    );
    return ReadingAndAppearanceModel.fromJson(response.data);
  }

  @override
  Future<List<ResearchInterestsModel>> getResearchInterests() async {
    final response = await _dioClient.get(
      MyConstants.retrieveResearchInterests,
    );
    final List<dynamic> interests = response.data['data'];
    return interests
        .map(
          (item) =>
              ResearchInterestsModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<String> initiateFullAccountDataExport() async {
    final response = await _dioClient.post(
      MyConstants.initiateFullAccountDataExport,
    );
    return response.data['message'];
  }

  @override
  Future<List<ResearchInterestsModel>> replaceResearchInterests({
    required List<ResearchInterestsModel> interests,
  }) async {
    final response = await _dioClient.put(
      MyConstants.retrieveResearchInterests,
      data: interests.map((e) => e.toJson()).toList(),
    );
    final data = response.data['data'] as List;

    return data.map((e) => ResearchInterestsModel.fromJson(e)).toList();
  }

  @override
  Future<String> revokeAllActiveSessionExceptCurrent() async {
    final response = await _dioClient.delete(
      MyConstants.revokeAllSessionsExceptTheCurrentOne,
    );
    return response.data['message'];
  }

  @override
  Future<FeedAndAiPreferenceModel> updateFeedAndAiPreference({
    required FeedAndAiPreferenceModel preferences,
  }) async {
    final response = await _dioClient.patch(
      MyConstants.updateFeedAndAiPreferences,
      data: preferences.toJson(),
    );
    return FeedAndAiPreferenceModel.fromJson(response.data);
  }

  @override
  Future<NotificationPreferencesModel> updateNotificationPreferences({
    required NotificationPreferencesModel preferences,
  }) async {
    final response = await _dioClient.patch(
      MyConstants.updateNotificationPreferences,
      data: preferences.toJson(),
    );
    return NotificationPreferencesModel.fromJson(response.data['data']);
  }

  @override
  Future<PrivacySettingsModel> updatePrivacySettings({
    required PrivacySettingsModel settings,
  }) async {
    final response = await _dioClient.patch(
      MyConstants.updatePrivacySettings,
      data: settings.toJson(),
    );
    return PrivacySettingsModel.fromJson(response.data);
  }

  @override
  Future<ReadingAndAppearanceModel> updateThemeandFontDisplayPreferences({
    required ColorMode colorMode,
    required FontSize defaultFontSize,
  }) async {
    final response = await _dioClient.patch(
      MyConstants.updateThemeAndFontDisplayPreferences,
      data: {
        'colorMode': colorMode.name.toUpperCase(),
        'defaultFontSize': defaultFontSize.name.toUpperCase(),
      },
    );
    return ReadingAndAppearanceModel.partial(response.data);
  }

  @override
  Future<ReadingAndAppearanceModel>
  updateReadingListVisibilityandAnnotationColorPalette({
    required Visible defaultReadingListVisibility,
    required List<String> annotationHighlightColors,
  }) async {
    final response = await _dioClient.patch(
      MyConstants.updateReadingListVisibilityAndAnnotationColorPalette,
      data: {
        'defaultReadingListVisibility': defaultReadingListVisibility.name
            .toUpperCase(),
        'annotationHighlightColors': annotationHighlightColors,
      },
    );
    return ReadingAndAppearanceModel.partialVisibility(response.data);
  }
}
