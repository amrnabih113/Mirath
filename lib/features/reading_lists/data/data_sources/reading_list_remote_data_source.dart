import '../models/reading_list_response.dart';
import '../models/reading_lists_response.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/entities/reading_list_query_params.dart';
import '../../domain/entities/update_reading_list_params.dart';

abstract class ReadingListRemoteDataSource {
  Future<ReadingListsResponse> getReadingLists(ReadingListQueryParams params);

  Future<ReadingListResponse> createReadingList(CreateReadingListParams params);

  Future<ReadingListResponse> getReadingListById(String id);

  Future<ReadingListResponse> updateReadingList(UpdateReadingListParams params);

  Future<void> deleteReadingList(String id);

  Future<void> addPaperToList(AddPaperToListParams params);

  Future<void> removePaperFromList({
    required String readingListId,
    required String paperId,
  });

  Future<void> saveReadingList(String id);

  Future<void> unsaveReadingList(String id);
}
