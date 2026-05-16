import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/library_data_model.dart';
import '../models/reading_history_model.dart';
import '../models/saved_papers_model.dart';
import 'library_data_sources.dart';

class LibraryDataSourcesImpl implements LibraryDataSources {
  final DioClient dioClient;

  LibraryDataSourcesImpl({required this.dioClient});

  @override
  Future<LibraryDataModel> getLibraryData() async {
    final response = await dioClient.get(MyConstants.getLibraryStats);
    return LibraryDataModel.fromJson(response.data['data']);
  }

  @override
  Future<ReadingHistoryModel> getReadingHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dioClient.get(
      MyConstants.getReadingHistory,
      queryParameters: {'page': page, 'limit': limit},
    );
    return ReadingHistoryModel.fromJson(response.data);
  }

  @override
  Future<SavedPapersModel> getAllSavedPapers() async {
    final response = await dioClient.get(MyConstants.getAllSavedPapers);
    return SavedPapersModel.fromJson(response.data);
  }

  @override
  Future<void> removePaperFromReadingHistory(String paperId) async {
    final response = await dioClient.delete(
      MyConstants.removePaperFromReadingHistory.replaceAll(
        '{paperId}',
        paperId,
      ),
    );
    return response.data['message'];
  }

  @override
  Future<void> updateReadingHistory(String paperId) async {
    final response = await dioClient.post(
      MyConstants.updateReadingHistory.replaceAll('{paperId}', paperId),
    );
    return response.data['message'];
  }

  @override
  Future<void> clearAllReadingHistory() async {
    final response = await dioClient.delete(MyConstants.clearAllReadingHistory);
    return response.data['message'];
  }
}
