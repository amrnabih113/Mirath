import 'package:dartz/dartz.dart';

import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/cache_notifier.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failuors.dart';
import '../../domain/entities/library_data.dart';
import '../../domain/entities/reading_history.dart';
import '../../domain/entities/saved_papers.dart';
import '../../domain/repositories/library_repository.dart';
import '../data_sources/library_data_sources.dart';
import '../models/library_data_model.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryDataSources libraryDataSources;
  final HiveCacheService cacheService;

  LibraryRepositoryImpl({
    required this.libraryDataSources,
    required this.cacheService,
  });

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
  Future<Either<Failure, List<SavedPaper>>> getAllSavedPapers() async {
    try {
      final response = await libraryDataSources.getAllSavedPapers();
      return Right(response.data);
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
      // 1. Try to return cached data immediately (allow stale) and revalidate
      final cached = await cacheService.getJson(
        CacheKeys.libraryStats(),
        allowStale: true,
      );
      if (cached != null) {
        final cachedModel = LibraryDataModel.fromJson(cached);
        // Revalidate in background
        libraryDataSources
            .getLibraryData()
            .then((remote) async {
              try {
                await cacheService.putJson(
                  CacheKeys.libraryStats(),
                  remote.toJson(),
                );
              } catch (_) {}
            })
            .catchError((_) {});
        return Right(cachedModel);
      }

      // 2. No cache → fetch remote
      final response = await libraryDataSources.getLibraryData();
      await cacheService.putJson(CacheKeys.libraryStats(), response.toJson());
      // notify subscribers
      CacheNotifier.instance.notify(CacheKeys.libraryStats());
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      // Try to return stale cached data if available
      final cached = await cacheService.getJson(
        CacheKeys.libraryStats(),
        allowStale: true,
      );
      if (cached != null) {
        final model = LibraryDataModel.fromJson(cached);
        return Right(model);
      }
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      // Fallback to cached value if available
      final cached = await cacheService.getJson(
        CacheKeys.libraryStats(),
        allowStale: true,
      );
      if (cached != null) {
        final model = LibraryDataModel.fromJson(cached);
        return Right(model);
      }
      return Left(ServerFailure('Failed to get Library Stats'));
    }
  }

  @override
  Future<Either<Failure, List<ReadingHistoryPaper>>> getReadingHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await libraryDataSources.getReadingHistory(
        page: page,
        limit: limit,
      );
      return Right(response.data);
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
