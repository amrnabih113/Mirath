import '../models/reading_list_response.dart';
import '../models/reading_lists_response.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';

abstract class ReadingListRemoteDataSource {
  Future<ReadingListsResponse> getReadingLists({String? ownerId});

  Future<ReadingListResponse> createReadingList(CreateReadingListParams params);

  Future<ReadingListResponse> getReadingListById(String id);

  Future<void> addPaperToList(AddPaperToListParams params);

  Future<void> removePaperFromList({
    required String readingListId,
    required String paperId,
  });
}
