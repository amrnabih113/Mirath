import 'package:share_plus/share_plus.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/discussions/domain/entities/discussion.dart';
import 'package:mirath/features/users/domain/entities/user.dart';
import 'package:mirath/features/reading_lists/domain/entities/reading_list.dart';
import 'package:mirath/core/utils/my_logger.dart';

/// Service to handle sharing of various content types within the app
/// Generates deep links and uses share_plus for system-level sharing
/// Deep links open the app directly if installed, otherwise fall back to web
class SharingService {
  // Deep link scheme for app - opens app if installed
  static const String deepLinkScheme = 'mirath://';

  /// Share a paper with a deep link
  static Future<void> sharePaper(PaperEntity paper) async {
    try {
      final title = paper.title ?? 'Untitled Paper';
      final authors = paper.authors?.join(', ') ?? 'Unknown Author';
      final deepLink = _generatePaperDeepLink(paper.id);
      final message = '$title\n\nBy: $authors\n\nRead on Mirath:\n$deepLink';

      await Share.share(message, subject: title);
      MyLogger.info('[SharingService] Shared paper: ${paper.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing paper: $e');
    }
  }

  /// Share a discussion with a deep link
  static Future<void> shareDiscussion(Discussion discussion) async {
    try {
      final title = discussion.title ?? 'Discussion';
      final deepLink = _generateDiscussionDeepLink(discussion.id);
      final message = '$title\n\nJoin the discussion on Mirath:\n$deepLink';

      await Share.share(message, subject: title);
      MyLogger.info('[SharingService] Shared discussion: ${discussion.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing discussion: $e');
    }
  }

  /// Share a user profile with a deep link
  static Future<void> shareProfile(User user) async {
    try {
      final name = user.fullName ?? 'User Profile';
      final deepLink = _generateProfileDeepLink(user.id);
      final message = 'Check out $name\'s profile on Mirath:\n$deepLink';

      await Share.share(message, subject: 'Follow $name on Mirath');
      MyLogger.info('[SharingService] Shared profile: ${user.id}');
    } catch (e) {
      MyLogger.error('[SharingService] Error sharing profile: $e');
    }
  }

  /// Share a reading list with a deep link
  static Future<void> shareReadingList(ReadingList readingList) async {
    try {
      final title = readingList.title;
      final description = readingList.description ?? '';
      final deepLink = _generateReadingListDeepLink(readingList.id);
      final message = '$title\n\n$description\n\nView on Mirath:\n$deepLink';

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

  /// Generate a deep link for a paper
  /// Format: mirath://papers/paperId
  static String _generatePaperDeepLink(String paperId) {
    return '${deepLinkScheme}papers/$paperId';
  }

  /// Generate a deep link for a discussion
  /// Format: mirath://discussions/discussionId
  static String _generateDiscussionDeepLink(String discussionId) {
    return '${deepLinkScheme}discussions/$discussionId';
  }

  /// Generate a deep link for a user profile
  /// Format: mirath://users/userId
  static String _generateProfileDeepLink(String userId) {
    return '${deepLinkScheme}users/$userId';
  }

  /// Generate a deep link for a reading list
  /// Format: mirath://reading-lists/readingListId
  static String _generateReadingListDeepLink(String readingListId) {
    return '${deepLinkScheme}reading-lists/$readingListId';
  }
}
