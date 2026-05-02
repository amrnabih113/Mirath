import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/exceptions.dart';
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
  Future<Either<Failure, void>> clearAllReadingHistory() async {
    try {
      await libraryDataSources.clearAllReadingHistory();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to clear reading history'));
    }
  }

  @override
  Future<Either<Failure, SavedPapers>> getAllSavedPapers() async {
    try {
      final response = await libraryDataSources.getAllSavedPapers();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get all saved papers'));
    }
  }

  @override
  Future<Either<Failure, LibraryData>> getLibraryData() async {
    try {
      final response = await libraryDataSources.getLibraryData();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get Library Stats'));
    }
  }

  @override
  Future<Either<Failure, List<ReadingHistory>>> getReadingHistory() async {
    try {
      final response = await libraryDataSources.getReadingHistory();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to get reading history'));
    }
  }

  @override
  Future<Either<Failure, void>> removePaperFromReadingHistory(
    String paperId,
  ) async {
    try {
      final response = await libraryDataSources.removePaperFromReadingHistory(
        paperId,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to remove paper from reading history'));
    }
  }

  @override
  Future<Either<Failure, void>> updateReadingHistory(String paperId) async {
    try {
      final response = await libraryDataSources.updateReadingHistory(paperId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to update reading history'));
    }
  }
}
