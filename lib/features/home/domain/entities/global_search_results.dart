import 'package:equatable/equatable.dart';

import '../../../discussions/domain/entities/discussion.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../../../users/domain/entities/user.dart';

class GlobalSearchResults extends Equatable {
  final List<Discussion> discussions;
  final List<ReadingList> readingLists;
  final List<User> researchers;

  const GlobalSearchResults({
    required this.discussions,
    required this.readingLists,
    required this.researchers,
  });

  const GlobalSearchResults.empty()
    : discussions = const [],
      readingLists = const [],
      researchers = const [];

  GlobalSearchResults copyWith({
    List<Discussion>? discussions,
    List<ReadingList>? readingLists,
    List<User>? researchers,
  }) {
    return GlobalSearchResults(
      discussions: discussions ?? this.discussions,
      readingLists: readingLists ?? this.readingLists,
      researchers: researchers ?? this.researchers,
    );
  }

  @override
  List<Object?> get props => [discussions, readingLists, researchers];
}
