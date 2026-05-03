import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/library/domain/entities/saved_papers.dart';

abstract class LibraryRepository {
  Future<Either<Failure, LibraryData>> getLibraryData();

  Future<Either<Failure, List<ReadingHistoryPaper>>> getReadingHistory();

  Future<Either<Failure, List<SavedPaper>>> getAllSavedPapers();

  Future<Either<Failure, void>> updateReadingHistory(String paperId);

  Future<Either<Failure, void>> clearAllReadingHistory();

  Future<Either<Failure, void>> removePaperFromReadingHistory(String paperId);
}
