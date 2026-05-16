import '../models/library_data_model.dart';
import '../models/reading_history_model.dart';
import '../models/saved_papers_model.dart';

abstract class LibraryDataSources {
  Future<void> clearAllReadingHistory();

  Future<SavedPapersModel> getAllSavedPapers();

  Future<LibraryDataModel> getLibraryData();

  Future<ReadingHistoryModel> getReadingHistory({int page = 1, int limit = 20});

  Future<void> removePaperFromReadingHistory(String paperId);

  Future<void> updateReadingHistory(String paperId);
}
