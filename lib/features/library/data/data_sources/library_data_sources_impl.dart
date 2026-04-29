import 'package:mirath/core/network/dio_client.dart';
import 'package:mirath/core/utils/my_constants.dart';
import 'package:mirath/features/library/data/data_sources/library_data_sources.dart';
import 'package:mirath/features/library/data/models/library_data_model.dart';
import 'package:mirath/features/library/data/models/reading_history_model.dart';
import 'package:mirath/features/library/data/models/saved_papers_model.dart';
import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/library/domain/entities/saved_papers.dart';

class LibraryDataSourcesImpl implements LibraryDataSources {
  final DioClient dioClient;

  LibraryDataSourcesImpl({required this.dioClient});

  @override
  Future<LibraryData> getLibraryData() async {
    final response = await dioClient.get(MyConstants.getLibraryStats);
    return LibraryDataModel.fromJson(response.data['data']);
  }

  @override
  Future<ReadingHistory> getReadingHistory() async {
    final response = await dioClient.get(MyConstants.getReadingHistory);
    return ReadingHistoryModel.fromJson(response.data);
  }

  @override
  Future<SavedPapers> getAllSavedPapers() async {
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
      data: paperId,
    );
    return response.data['message'];
  }

  @override
  Future<void> updateReadingHistory(String paperId) async {
    final response = await dioClient.post(
      MyConstants.updateReadingHistory.replaceAll('{paperId}', paperId),
      data: paperId,
    );
    return response.data['message'];
  }

  @override
  Future<void> clearAllReadingHistory() async {
    final response = await dioClient.delete(MyConstants.clearAllReadingHistory);
    return response.data['message'];
  }
}
