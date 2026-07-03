import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mirath/core/cache/cache_keys.dart';
import 'package:mirath/core/cache/hive_cache_service.dart';
import 'package:mirath/core/usecases/no_params.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/domain/entities/all_active_session_entity.dart';
import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';
import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';
import 'package:mirath/features/settings/domain/usecases/change_email_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/change_username_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/confirn_email_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/deactive_account_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/delete_account_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/disconnect_google_account_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/export_annotations_and_notes_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/export_reading_list_as_file_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/get_all_active_session_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/get_feed_ai_preference_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/get_notification_preference_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/get_privacy_settings_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/get_reading_and_appearance_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/get_research_interest_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/initiate_full_account_data_export_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/replace_research_interest_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/revoke_all_active_session_except_current_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/update_feed_ai_preference_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/update_notification_preference_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/update_password_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/update_privacy_settings_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/update_theme_font_display_preference_usecase.dart';
import 'package:mirath/features/settings/domain/usecases/update_visibility_and_annotation_usecase.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.changeEmailUsecase,
    required this.confirmEmailUsecase,
    required this.changeUserNameUsecase,
    required this.updatePasswordUsecase,
    required this.disconnectGoogleAccountUsecase,
    required this.getAllActiveSessionUsecase,
    required this.revokeAllActiveSessionExceptCurrentUsecase,
    required this.getFeedAiPreferenceUsecase,
    required this.updateFeedAiPreferenceUsecase,
    required this.getResearchInterestsUsecase,
    required this.replaceResearchInterestUsecase,
    required this.getReadingAndAppearanceUsecase,
    required this.updateThemeFontDisplayPreferenceUsecase,
    required this.updateVisibilityAndAnnotationUsecase,
    required this.getNotificationPreferenceUsecase,
    required this.updateNotificationPreferenceUsecase,
    required this.getPrivacySettingsUsecase,
    required this.updatePrivacySettingsUsecase,
    required this.initiateFullAccountDataExportUsecase,
    required this.exportReadingListAsFileUsecase,
    required this.exportAnnotationsAndNotesUsecase,
    required this.deactiveAccountUsecase,
    required this.deleteAccountUsecase,
    required this.cacheService,
  }) : super(SettingsInitial());

  final ChangeEmailUsecase changeEmailUsecase;
  final ConfirmEmailUsecase confirmEmailUsecase;
  final ChangeUsernameUsecase changeUserNameUsecase;
  final UpdatePasswordUsecase updatePasswordUsecase;
  final DisconnectGoogleAccountUsecase disconnectGoogleAccountUsecase;
  final GetAllActiveSessionUsecase getAllActiveSessionUsecase;
  final RevokeAllActiveSessionExceptCurrentUsecase
  revokeAllActiveSessionExceptCurrentUsecase;
  final GetFeedAiPreferenceUsecase getFeedAiPreferenceUsecase;
  final UpdateFeedAiPreferenceUsecase updateFeedAiPreferenceUsecase;
  final GetResearchInterestUsecase getResearchInterestsUsecase;
  final ReplaceResearchInterestUsecase replaceResearchInterestUsecase;
  final GetReadingAndAppearanceUsecase getReadingAndAppearanceUsecase;
  final UpdateThemeFontDisplayPreferenceUsecase
  updateThemeFontDisplayPreferenceUsecase;
  final UpdateVisibilityAndAnnotationUsecase
  updateVisibilityAndAnnotationUsecase;
  final GetNotificationPreferenceUsecase getNotificationPreferenceUsecase;
  final UpdateNotificationPreferenceUsecase updateNotificationPreferenceUsecase;
  final GetPrivacySettingsUsecase getPrivacySettingsUsecase;
  final UpdatePrivacySettingsUsecase updatePrivacySettingsUsecase;
  final InitiateFullAccountDataExportUsecase
  initiateFullAccountDataExportUsecase;
  final ExportReadingListAsFileUsecase exportReadingListAsFileUsecase;
  final ExportAnnotationsAndNotesUsecase exportAnnotationsAndNotesUsecase;
  final DeactiveAccountUsecase deactiveAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final HiveCacheService cacheService;
  // Account & Security
  Future<void> changeUsername({required String newUsername}) async {
    emit(SettingsLoading());
    var result = await changeUserNameUsecase.call(newUsername);
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) =>
          emit(SettingsSuccess<String>(data: 'Username updated successfully')),
    );
  }

  Future<void> changeEmail({required String newEmail}) async {
    emit(SettingsLoading());
    var result = await changeEmailUsecase.call(newEmail);
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(
          data: 'A verification code has been sent to your new email address',
        ),
      ),
    );
  }

  Future<void> confirmEmail({
    required String newEmail,
    required String otpCode,
  }) async {
    emit(SettingsLoading());
    var result = await confirmEmailUsecase.call(Tuple2(newEmail, otpCode));
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) =>
          emit(SettingsSuccess<String>(data: 'Email confirmed successfully')),
    );
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewpassword,
  }) async {
    emit(SettingsLoading());
    var result = await updatePasswordUsecase.call(
      Tuple3(currentPassword, newPassword, confirmNewpassword),
    );
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(
          data:
              'Password updated successfully. You have been logged out of all other devices.',
        ),
      ),
    );
  }

  Future<void> disconnectGoogleAccount() async {
    emit(SettingsLoading());
    var result = await disconnectGoogleAccountUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(data: 'Google account unlinked successfully'),
      ),
    );
  }

  Future<void> getAllActiveSessions() async {
    emit(SettingsLoading());
    var result = await getAllActiveSessionUsecase.call(NoParams());
    result.fold(
      (failure) {
        emit(SettingsFailure(errormessage: failure.message));
      },
      (sessions) {
        emit(SettingsSuccess<List<AllActiveSessionEntity>>(data: sessions));
      },
    );
  }

  Future<void> revokeAllActiveSessionsExceptCurrent() async {
    emit(SettingsLoading());
    var result = await revokeAllActiveSessionExceptCurrentUsecase.call(
      NoParams(),
    );
    result.fold(
      (failure) {
        emit(SettingsFailure(errormessage: failure.message));
      },
      (_) {
        emit(
          SettingsSuccess<String>(
            data: 'Successfully logged out from all other devices',
          ),
        );
      },
    );
  }

  // Feed AI Preference

  Future<void> getFeedAipreference() async {
    emit(SettingsLoading());
    var result = await getFeedAiPreferenceUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) => emit(SettingsSuccess<FeedAndAiPreferenceEntity>(data: data)),
    );
  }

  // Update Feed AI Preference
  Future<void> updateFeedAipreference({
    required FeedAndAiPreferenceEntity preference,
  }) async {
    final previousState = state;
    if (state is SettingsSuccess) {
      final currentSuccessState = state as SettingsSuccess;
      emit(currentSuccessState.copyWith(data: preference, isUpdating: true));
      var result = await updateFeedAiPreferenceUsecase.call(preference);
      result.fold(
        (failure) {
          debugPrint('Update Feed AI Preference failed: ${failure.message}');
          emit(previousState);
        },
        (_) {
          emit(SettingsSuccess(data: preference, isUpdating: false));
        },
      );
    }
  }

  // get research interests
  Future<void> getResearchInterests() async {
    emit(SettingsLoading());
    var result = await getResearchInterestsUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) =>
          emit(SettingsSuccess<List<ResearchInterestsEntitiy>>(data: data)),
    );
  }

  // replace research interests
  Future<void> replaceResearchInterests({
    required List<ResearchInterestsEntitiy> interests,
  }) async {
    emit(SettingsLoading());
    var result = await replaceResearchInterestUsecase.call(interests);
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) =>
          emit(SettingsSuccess<List<ResearchInterestsEntitiy>>(data: data)),
    );
  }

  // get reading and appearance settings
  Future<void> getReadingAndAppearanceSettings() async {
    emit(SettingsLoading());
    var result = await getReadingAndAppearanceUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) => emit(SettingsSuccess<ReadingAndAppearanceEntitiy>(data: data)),
    );
  }

  // update reading and appearance settings
  Future<void> updateThemeFontDisplayPreference({
    required ColorMode mode,
    required FontSize size,
  }) async {
    emit(SettingsLoading());
    var result = await updateThemeFontDisplayPreferenceUsecase.call(
      tuple2(mode, size),
    );
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) => emit(SettingsSuccess<ReadingAndAppearanceEntitiy>(data: data)),
    );
  }

  Future<void> updateVisibilityAndAnnotation({
    required Visible visMode,
    required List<String> annotationColors,
  }) async {
    emit(SettingsLoading());
    var result = await updateVisibilityAndAnnotationUsecase.call(
      Tuple2(visMode, annotationColors),
    );
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) => emit(SettingsSuccess<ReadingAndAppearanceEntitiy>(data: data)),
    );
  }

  // get notification preferences
  Future<void> getNotificationPreferences() async {
    emit(SettingsLoading());
    var result = await getNotificationPreferenceUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) =>
          emit(SettingsSuccess<NotificationPreferencesEntity>(data: data)),
    );
  }

  // update notification preferences
  Future<void> updateNotificationPreferences({
    required NotificationPreferencesEntity preference,
  }) async {
    final previousState = state;
    if (state is SettingsSuccess) {
      final currentSuccessState = state as SettingsSuccess;

      emit(currentSuccessState.copyWith(data: preference, isUpdating: true));

      var result = await updateNotificationPreferenceUsecase.call(preference);

      result.fold(
        (failure) {
          emit(previousState);
        },
        (_) {
          emit(SettingsSuccess(data: preference, isUpdating: false));
        },
      );
    }
  }

  // get privacy settings
  Future<void> getPrivacySettings() async {
    emit(SettingsLoading());
    var result = await getPrivacySettingsUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (data) => emit(SettingsSuccess<PrivacySettingsEntitiy>(data: data)),
    );
  }

  // update privacy settings
  Future<void> updatePrivacySettings({
    required PrivacySettingsEntitiy preference,
  }) async {
    final previousState = state;
    if (state is SettingsSuccess) {
      final currentSuccessState = state as SettingsSuccess;
      emit(currentSuccessState.copyWith(data: preference, isUpdating: true));
      var result = await updatePrivacySettingsUsecase.call(preference);
      result.fold(
        (failure) {
          emit(previousState);
        },
        (_) {
          emit(SettingsSuccess(data: preference, isUpdating: false));
        },
      );
    }
  }

  // initiate full account data export
  Future<void> initiateFullAccountDataExport() async {
    emit(SettingsLoading());
    var result = await initiateFullAccountDataExportUsecase.call(NoParams());
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(data: 'Data export requested successfully'),
      ),
    );
  }

  // export reading lists
  Future<void> exportReadingLists({required ExportListFormate formate}) async {
    emit(SettingsLoading());
    var result = await exportReadingListAsFileUsecase.call(formate);
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(data: 'Reading list exported successfully'),
      ),
    );
  }

  // export annotations and notes
  Future<void> exportAnnotationsAndNotes({
    required ExportAnnotationsFormate formate,
  }) async {
    emit(SettingsLoading());
    var result = await exportAnnotationsAndNotesUsecase.call(formate);
    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(data: 'Annotations exported successfully'),
      ),
    );
  }

  // deactive account
  Future<void> deactiveAccount({required String password}) async {
    emit(SettingsLoading());
    var result = await deactiveAccountUsecase.call(password);

    if (result.isRight()) {
      await cacheService.clearPrefix(CacheKeys.settingsPrefix);
    }

    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(
          data:
              'Account successfully deactivated. You can log in anytime to reactivate.',
        ),
      ),
    );
  }

  // delete account
  Future<void> deleteAccount({required String password}) async {
    emit(SettingsLoading());
    var result = await deleteAccountUsecase.call(password);

    if (result.isRight()) {
      await cacheService.clearPrefix(CacheKeys.settingsPrefix);
    }

    result.fold(
      (failure) => emit(SettingsFailure(errormessage: failure.message)),
      (_) => emit(
        SettingsSuccess<String>(
          data:
              'Account will be deleted permanently in 30 days. You can log in anytime before to reactivate.',
        ),
      ),
    );
  }
}
