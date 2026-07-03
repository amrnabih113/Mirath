import 'package:dartz/dartz.dart';
import 'package:mirath/core/cache/cache_keys.dart';
import 'package:mirath/core/cache/hive_cache_service.dart';
import 'package:mirath/core/error/exceptions.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/features/settings/data/data-sources/settings_remote_data_source.dart';
import 'package:mirath/features/settings/data/models/feed_and_ai_preference_model.dart';
import 'package:mirath/features/settings/data/models/notification_preferences_model.dart';
import 'package:mirath/features/settings/data/models/privacy_settings_model.dart';
import 'package:mirath/features/settings/data/models/reading_and_appearance_model.dart';
import 'package:mirath/features/settings/data/models/research_interests_model.dart';
import 'package:mirath/features/settings/domain/entities/all_active_session_entity.dart';
import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';
import 'package:mirath/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';
import 'package:mirath/features/settings/domain/entities/reading_and_appearance_entitiy.dart';
import 'package:mirath/features/settings/domain/entities/research_interests_entitiy.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final HiveCacheService cacheService;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheService,
  });
  @override
  Future<Either<Failure, void>> changeUsername({
    required String newUsername,
  }) async {
    try {
      await remoteDataSource.changeUsername(newUsername: newUsername);
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to change username'));
    }
  }

  @override
  Future<Either<Failure, void>> changeEmail({required String newEmail}) async {
    try {
      await remoteDataSource.changeEmail(newEmail: newEmail);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirmEmail({
    required String newEmail,
    required String otpCode,
  }) async {
    try {
      await remoteDataSource.confirmEmail(newEmail: newEmail, otpCode: otpCode);
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to confirm email'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await remoteDataSource.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to update password'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectGoogleAccount() async {
    try {
      await remoteDataSource.disconnectGoogleAccount();
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to disconnect Google account'));
    }
  }

  @override
  Future<Either<Failure, List<AllActiveSessionEntity>>>
  getAllActiveSession() async {
    try {
      final result = await remoteDataSource.getAllActiveSession();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get all active sessions'));
    }
  }

  @override
  Future<Either<Failure, void>> revokeAllActiveSessionExceptCurrent() async {
    try {
      await remoteDataSource.revokeAllActiveSessionExceptCurrent();
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(
        ServerFailure('Failed to revoke all active sessions except current'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> initiateFullAccountDataExport() async {
    try {
      await remoteDataSource.initiateFullAccountDataExport();
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to initiate full account data export'));
    }
  }

  @override
  Future<Either<Failure, void>> exportAnnotationsAndNotes({
    required ExportAnnotationsFormate formate,
  }) async {
    try {
      await remoteDataSource.exportAnnotationsAndNotes(formate: formate);
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to export annotations and notes'));
    }
  }

  @override
  Future<Either<Failure, void>> exportReadingListsAsAFile({
    required ExportListFormate formate,
  }) async {
    try {
      await remoteDataSource.exportReadingListsAsAFile(formate: formate);
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to export reading lists as a file'));
    }
  }

  @override
  Future<Either<Failure, FeedAndAiPreferenceEntity>>
  getFeedAndAiPreference() async {
    try {
      final result = await remoteDataSource.getFeedAndAiPreference();
      await cacheService.putJson(CacheKeys.kFeedAndAi, (result).toJson());
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      final cached = await cacheService.getJson(CacheKeys.kPrivacy);
      if (cached != null) {
        return right(FeedAndAiPreferenceModel.fromJson(cached));
      }
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get Feed and AI Preferences'));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferencesEntity>>
  getNotificationPreferences() async {
    try {
      final result = await remoteDataSource.getNotificationPreferences();
      await cacheService.putJson(CacheKeys.kNotificationPrefs, result.toJson());
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      final cached = await cacheService.getJson(CacheKeys.kNotificationPrefs);
      if (cached != null) {
        return right(NotificationPreferencesModel.fromJson(cached));
      }
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('User not logged in'));
    }
  }

  @override
  Future<Either<Failure, PrivacySettingsEntitiy>> getPrivacySettings() async {
    try {
      final result = await remoteDataSource.getPrivacySettings();
      await cacheService.putJson(CacheKeys.kPrivacy, (result).toJson());
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      final cached = await cacheService.getJson(CacheKeys.kNotificationPrefs);
      if (cached != null) {
        return right(PrivacySettingsModel.fromJson(cached));
      }
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get privacy settings'));
    }
  }

  @override
  Future<Either<Failure, ReadingAndAppearanceEntitiy>>
  getReadingAndAppearance() async {
    final cached = await cacheService.getJson(CacheKeys.kReadingAppearance);
    if (cached != null) {
      return right(ReadingAndAppearanceModel.fromJson(cached));
    }
    try {
      final result = await remoteDataSource.getReadingAndAppearance();
      await cacheService.putJson(
        CacheKeys.kReadingAppearance,
        (result).toJson(),
      );
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get reading and appearance settings'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ResearchInterestsEntitiy>>>
  getResearchInterests() async {
    final cached = await cacheService.getJsonList(CacheKeys.kResearchInterests);
    if (cached != null) {
      return right(cached.map(ResearchInterestsModel.fromJson).toList());
    }
    try {
      final result = await remoteDataSource.getResearchInterests();
      await cacheService.putJsonList(
        CacheKeys.kResearchInterests,
        result.map((e) => (e).toJson()).toList(),
      );
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get research interests'));
    }
  }

  @override
  Future<Either<Failure, List<ResearchInterestsEntitiy>>>
  replaceResearchInterests({
    required List<ResearchInterestsEntitiy> interests,
  }) async {
    try {
      final models = interests.map((e) => e as ResearchInterestsModel).toList();
      final result = await remoteDataSource.replaceResearchInterests(
        interests: models,
      );
      await cacheService.putJsonList(
        CacheKeys.kResearchInterests,
        result.map((e) => (e).toJson()).toList(),
      );
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to replace research interests'));
    }
  }

  @override
  Future<Either<Failure, FeedAndAiPreferenceEntity>> updateFeedAndAiPreference({
    required FeedAndAiPreferenceEntity preferences,
  }) async {
    try {
      final result = await remoteDataSource.updateFeedAndAiPreference(
        preferences: FeedAndAiPreferenceModel.fromEntity(preferences),
      );
      await cacheService.putJson(CacheKeys.kFeedAndAi, result.toJson());
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to update feed and AI preference'));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferencesEntity>>
  updateNotificationPreferences({
    required NotificationPreferencesEntity preferences,
  }) async {
    try {
      final result = await remoteDataSource.updateNotificationPreferences(
        preferences: NotificationPreferencesModel.fromEntity(preferences),
      );
      await cacheService.putJson(CacheKeys.kNotificationPrefs, result.toJson());
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('User not logged in'));
    }
  }

  @override
  Future<Either<Failure, PrivacySettingsEntitiy>> updatePrivacySettings({
    required PrivacySettingsEntitiy settings,
  }) async {
    try {
      final result = await remoteDataSource.updatePrivacySettings(
        settings: PrivacySettingsModel.fromEntity(settings),
      );
      await cacheService.putJson(CacheKeys.kPrivacy, result.toJson());
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to update privacy settings'));
    }
  }

  @override
  Future<Either<Failure, ReadingAndAppearanceEntitiy>>
  updateReadingListVisibilityandAnnotationColorPalette({
    required Visible defaultReadingListVisibility,
    required List<String> annotationHighlightColors,
  }) async {
    try {
      final result = await remoteDataSource
          .updateReadingListVisibilityandAnnotationColorPalette(
            defaultReadingListVisibility: defaultReadingListVisibility,
            annotationHighlightColors: annotationHighlightColors,
          );
      await cacheService.putJson(
        CacheKeys.kReadingAppearance,
        (result).toJson(),
      );
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(
        ServerFailure(
          'Failed to update reading list visibility and annotation color palette',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ReadingAndAppearanceEntitiy>>
  updatethemeAndDisplayPreferences({
    required ColorMode colorMode,
    required FontSize defaultFontSize,
  }) async {
    try {
      final result = await remoteDataSource
          .updateThemeandFontDisplayPreferences(
            colorMode: colorMode,
            defaultFontSize: defaultFontSize,
          );
      await cacheService.putJson(
        CacheKeys.kReadingAppearance,
        (result).toJson(),
      );
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(
        ServerFailure('Failed to update theme and display preferences'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deactivateUserAccount({
    required String password,
  }) async {
    try {
      await remoteDataSource.deactivateUserAccount(password: password);
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to deactivate user account'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount({
    required String password,
  }) async {
    try {
      await remoteDataSource.deleteUserAccount(password: password);
      return right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to delete user account'));
    }
  }
}
