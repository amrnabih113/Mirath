import 'package:mirath/features/library/data/models/library_data_model.dart';
import 'package:mirath/features/library/data/models/reading_history_model.dart';
import 'package:mirath/features/library/data/models/saved_papers_model.dart';

abstract class LibraryDataSources {
  Future<void> clearAllReadingHistory();

  Future<SavedPapersModel> getAllSavedPapers();

  Future<LibraryDataModel> getLibraryData();

  Future<ReadingHistoryModel> getReadingHistory();

  Future<void> removePaperFromReadingHistory(String paperId);

  Future<void> updateReadingHistory(String paperId);
}
