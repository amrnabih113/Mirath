import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/reading_list_response.dart';
import '../models/reading_lists_response.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/entities/reading_list_query_params.dart';
import '../../domain/entities/update_reading_list_params.dart';
import 'reading_list_remote_data_source.dart';

class ReadingListRemoteDataSourceImpl implements ReadingListRemoteDataSource {
  final DioClient dioClient;

  const ReadingListRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ReadingListsResponse> getReadingLists(
    ReadingListQueryParams params,
  ) async {
    final path = params.all
        ? MyConstants.getAllReadingLists
        : MyConstants.getReadingLists;

    final response = await dioClient.get(
      path,
      queryParameters: params.toQueryParameters(),
    );

    return ReadingListsResponse.fromJson(response.data);
  }

  @override
  Future<ReadingListResponse> createReadingList(
    CreateReadingListParams params,
  ) async {
    final response = await dioClient.post(
      MyConstants.createReadingList,
      data: params.toJson(),
    );

    return ReadingListResponse.fromJson(response.data);
  }

  @override
  Future<ReadingListResponse> getReadingListById(String id) async {
    final path = MyConstants.getReadingListById.replaceAll('{id}', id);
    final response = await dioClient.get(path);

    return ReadingListResponse.fromJson(response.data);
  }

  @override
  Future<ReadingListResponse> updateReadingList(
    UpdateReadingListParams params,
  ) async {
    final path = MyConstants.updateReadingList.replaceAll(
      '{id}',
      params.readingListId,
    );

    final response = await dioClient.patch(path, data: params.toJson());
    return ReadingListResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteReadingList(String id) async {
    final path = MyConstants.deleteReadingList.replaceAll('{id}', id);
    await dioClient.delete(path);
  }

  @override
  Future<void> addPaperToList(AddPaperToListParams params) async {
    final path = MyConstants.addPaperToList.replaceAll(
      '{id}',
      params.readingListId,
    );

    await dioClient.post(path, data: params.toJson());
  }

  @override
  Future<void> removePaperFromList({
    required String readingListId,
    required String paperId,
  }) async {
    final path = MyConstants.removePaperFromList
        .replaceAll('{id}', readingListId)
        .replaceAll('{paperId}', paperId);

    await dioClient.delete(path);
  }

  @override
  Future<void> saveReadingList(String id) async {
    final path = MyConstants.saveReadingList.replaceAll('{id}', id);
    await dioClient.post(path);
  }

  @override
  Future<void> unsaveReadingList(String id) async {
    final path = MyConstants.unsaveReadingList.replaceAll('{id}', id);
    await dioClient.delete(path);
  }
}
