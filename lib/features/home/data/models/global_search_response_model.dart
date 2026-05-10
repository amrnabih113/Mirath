import '../../../discussions/data/models/discussion_model.dart';
import '../../../reading_lists/data/models/reading_list_model.dart';
import '../../../users/data/models/user_model.dart';

class GlobalSearchResponseModel {
  final List<DiscussionModel> discussions;
  final List<ReadingListModel> readingLists;
  final List<UserModel> researchers;

  const GlobalSearchResponseModel({
    required this.discussions,
    required this.readingLists,
    required this.researchers,
  });

  factory GlobalSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    List<dynamic> listForKeys(List<String> keys) {
      for (final key in keys) {
        final value = payload[key];
        if (value is List) {
          return value;
        }
      }
      return const [];
    }

    return GlobalSearchResponseModel(
      discussions: listForKeys(['discussions', 'discussionResults', 'items'])
          .whereType<Map<String, dynamic>>()
          .map(DiscussionModel.fromJson)
          .toList(),
      readingLists:
          listForKeys(['readingLists', 'readingListsResults', 'lists', 'items'])
              .whereType<Map<String, dynamic>>()
              .map(ReadingListModel.fromJson)
              .toList(),
      researchers: listForKeys([
        'researchers',
        'users',
        'results',
        'items',
      ]).whereType<Map<String, dynamic>>().map(UserModel.fromJson).toList(),
    );
  }
}
