import 'package:share_plus/share_plus.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/discussions/domain/entities/discussion.dart';
import 'package:mirath/features/users/domain/entities/user.dart';
import 'package:mirath/features/reading_lists/domain/entities/reading_list.dart';
import 'package:mirath/core/utils/my_logger.dart';

/// Service to handle sharing of various content types within the app
/// Generates shareable URLs using universal links that work across platforms
/// URLs can be handled by app's deep link configuration
class SharingService {
  // Universal link base - works with proper deep link configuration
  // For now using standard format that can be intercepted by the app
  static const String webBaseUrl = 'https://mirath-dev.web.app';

  /// Share a paper with a shareable link
  static Future<void> sharePaper(PaperEntity paper) async {
    try {
      final title = paper.title;
      final authors = paper.authors.join(', ');
      final shareUrl = _generatePaperUrl(paper.id);
      final message = '$title\n\nBy: $authors\n\nRead on Mirath:\n$shareUrl';

      await Share.share(message, subject: title);
      MyLogger.info('[SharingService] Shared paper: ${paper.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing paper: $e');
    }
  }

  /// Share a discussion with a shareable link
  static Future<void> shareDiscussion(Discussion discussion) async {
    try {
      final title = discussion.title;
      final shareUrl = _generateDiscussionUrl(discussion.id);
      final message = '$title\n\nJoin the discussion on Mirath:\n$shareUrl';

      await Share.share(message, subject: title);
      MyLogger.info('[SharingService] Shared discussion: ${discussion.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing discussion: $e');
    }
  }

  /// Share a user profile with a shareable link
  static Future<void> shareProfile(User user) async {
    try {
      final name = user.fullName;
      final shareUrl = _generateProfileUrl(user.id);
      final message = 'Check out $name\'s profile on Mirath:\n$shareUrl';

      await Share.share(message, subject: 'Follow $name on Mirath');
      MyLogger.info('[SharingService] Shared profile: ${user.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing profile: $e');
    }
  }

  /// Share a reading list with a shareable link
  static Future<void> shareReadingList(ReadingList readingList) async {
    try {
      final title = readingList.title;
      final description = readingList.description ?? '';
      final shareUrl = _generateReadingListUrl(readingList.id);
      final message = '$title\n\n$description\n\nView on Mirath:\n$shareUrl';

      await Share.share(message, subject: title);
      MyLogger.info('[SharingService] Shared reading list: ${readingList.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing reading list: $e');
    }
  }

  /// Share plain text content
  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
      MyLogger.info('[SharingService] Shared text');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing text: $e');
    }
  }

  /// Generate a shareable URL for a paper
  /// Format: https://mirath-dev.web.app/#/papers/paperId
  static String _generatePaperUrl(String paperId) {
    return '$webBaseUrl/#/papers/$paperId';
  }

  /// Generate a shareable URL for a discussion
  /// Format: https://mirath-dev.web.app/#/discussions/discussionId
  static String _generateDiscussionUrl(String discussionId) {
    return '$webBaseUrl/#/discussions/$discussionId';
  }

  /// Generate a shareable URL for a user profile
  /// Format: https://mirath-dev.web.app/#/users/userId
  static String _generateProfileUrl(String userId) {
    return '$webBaseUrl/#/users/$userId';
  }

  /// Generate a shareable URL for a reading list
  /// Format: https://mirath-dev.web.app/#/reading-lists/readingListId
  static String _generateReadingListUrl(String readingListId) {
    return '$webBaseUrl/#/reading-lists/$readingListId';
  }
}
