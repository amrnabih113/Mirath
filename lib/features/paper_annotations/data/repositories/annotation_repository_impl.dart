import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/utils/my_logger.dart';
import '../../domain/entites/highlight_entity.dart';
import '../../domain/repositories/annotation_repository.dart';
import '../data_sources/annotation_local_data_source.dart';
import '../data_sources/annotation_remote_data_source.dart';
import '../models/highlight_model.dart';

class AnnotationRepositoryImpl implements AnnotationRepository {
  final AnnotationRemoteDataSource remoteDataSource;
  final AnnotationLocalDataSource localDataSource;

  AnnotationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Highlight>>> getHighlights(String paperId) async {
    try {
      // Try to get from remote first
      try {
        final remoteHighlights = await remoteDataSource.getHighlights(paperId);
        if (remoteHighlights.isNotEmpty) {
          // Cache locally
          for (final highlight in remoteHighlights) {
            await localDataSource.saveHighlight(highlight);
          }
          return Right(remoteHighlights);
        }
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote fetch failed, falling back to local: $e',
        );
      }

      // Fallback to local storage
      final localHighlights = await localDataSource.getHighlights(paperId);
      return Right(localHighlights);
    } catch (e) {
      MyLogger.error('[AnnotationRepository] Error getting highlights: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Highlight>> saveHighlight(Highlight highlight) async {
    try {
      final model = HighlightModel.fromEntity(highlight);

      // Save locally first for immediate feedback
      await localDataSource.saveHighlight(model);

      // Try to sync with backend
      try {
        final savedHighlight = await remoteDataSource.saveHighlight(model);
        return Right(savedHighlight);
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote save failed, using local: $e',
        );
        return Right(model);
      }
    } catch (e) {
      MyLogger.error('[AnnotationRepository] Error saving highlight: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Highlight>> updateHighlight(
    Highlight highlight,
  ) async {
    try {
      final model = HighlightModel.fromEntity(highlight);

      // Update locally first
      await localDataSource.updateHighlight(model);

      // Try to sync with backend
      try {
        final updatedHighlight = await remoteDataSource.updateHighlight(model);
        return Right(updatedHighlight);
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote update failed, using local: $e',
        );
        return Right(model);
      }
    } catch (e) {
      MyLogger.error('[AnnotationRepository] Error updating highlight: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteHighlight(String highlightId) async {
    try {
      // Delete locally first
      await localDataSource.deleteHighlight(highlightId);

      // Try to sync with backend
      try {
        await remoteDataSource.deleteHighlight(highlightId);
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote delete failed, local deleted: $e',
        );
      }

      return const Right(null);
    } catch (e) {
      MyLogger.error('[AnnotationRepository] Error deleting highlight: $e');
      return Left(CacheFailure());
    }
  }
}
