import '../entities/reading_list.dart';
import '../entities/reading_list_query_params.dart';
import '../repositories/reading_list_repository.dart';

class ReadingListCacheUseCases {
  final ReadingListRepository repository;

  ReadingListCacheUseCases({required this.repository});

  Future<List<ReadingList>> getCachedReadingLists(
    ReadingListQueryParams params,
  ) {
    return repository.getCachedReadingLists(params);
  }

  Future<void> cacheReadingLists(
    List<ReadingList> readingLists,
    ReadingListQueryParams params,
  ) {
    return repository.cacheReadingLists(readingLists, params);
  }

  Future<ReadingList?> getCachedReadingListById(String id) {
    return repository.getCachedReadingListById(id);
  }

  Future<void> upsertCachedReadingList(ReadingList readingList) {
    return repository.upsertCachedReadingList(readingList);
  }

  Future<void> removeCachedReadingList(String id) {
    return repository.removeCachedReadingList(id);
  }

  Future<void> updateReadingListSavedState({
    required String readingListId,
    required bool isSaved,
  }) {
    return repository.updateReadingListSavedState(
      readingListId: readingListId,
      isSaved: isSaved,
    );
  }

  Future<void> updateReadingListDetailsCache(ReadingList readingList) {
    return repository.updateReadingListDetailsCache(readingList);
  }

  Future<void> updateReadingListPaperCache({
    required String readingListId,
    required String paperId,
    required bool isAdding,
  }) {
    return repository.updateReadingListPaperCache(
      readingListId: readingListId,
      paperId: paperId,
      isAdding: isAdding,
    );
  }
}
