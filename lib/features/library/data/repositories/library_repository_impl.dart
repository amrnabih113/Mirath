import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/data/data_sources/library_data_sources.dart';
import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/library/domain/entities/saved_papers.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryDataSources libraryDataSources;

  LibraryRepositoryImpl({required this.libraryDataSources});

  @override
  Future<Either<Failure, void>> clearAllReadingHistory() {
    // TODO: implement clearAllReadingHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SavedPapers>> getAllSavedPapers() {
    // TODO: implement getAllSavedPapers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LibraryData>> getLibraryData() {
    // TODO: implement getLibraryData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ReadingHistory>> getReadingHistory() {
    // TODO: implement getReadingHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removePaperFromReadingHistory(String paperId) {
    // TODO: implement removePaperFromReadingHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateReadingHistory(String paperId) {
    // TODO: implement updateReadingHistory
    throw UnimplementedError();
  }
}
