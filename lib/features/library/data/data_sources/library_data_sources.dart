import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/library/domain/entities/saved_papers.dart';

abstract class LibraryDataSources {
  Future<void> clearAllReadingHistory();

  Future<SavedPapers> getAllSavedPapers();

  Future<LibraryData> getLibraryData();

  Future<List<ReadingHistory>> getReadingHistory();

  Future<void> removePaperFromReadingHistory(String paperId);

  Future<void> updateReadingHistory(String paperId);
}
