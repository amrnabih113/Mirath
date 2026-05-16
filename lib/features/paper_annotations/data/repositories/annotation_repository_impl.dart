import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entites/highlight_entity.dart';
import '../../domain/entites/highlight_note_params.dart';
import '../../domain/entites/paper_highlights_params.dart';
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
      try {
        final remoteHighlights = await remoteDataSource.getHighlights(paperId);
        if (remoteHighlights.isNotEmpty) {
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

      final localHighlights = await localDataSource.getHighlights(paperId);
      return Right(localHighlights);
    } catch (e) {
      MyLogger.error('[AnnotationRepository] Error getting highlights: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Highlight>>> getAnnotatedHighlights(
    PaperHighlightsParams params,
  ) async {
    try {
      try {
        final remoteHighlights = await remoteDataSource.getAnnotatedHighlights(
          params.paperId,
          page: params.page,
          limit: params.limit,
        );
        return Right(remoteHighlights);
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote annotated highlights fetch failed, falling back to local: $e',
        );
      }

      final localHighlights = await localDataSource.getHighlights(
        params.paperId,
      );
      return Right(
        localHighlights
            .where((highlight) => highlight.note?.isNotEmpty == true)
            .toList(),
      );
    } catch (e) {
      MyLogger.error(
        '[AnnotationRepository] Error getting annotated highlights: $e',
      );
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Highlight>> saveHighlight(Highlight highlight) async {
    try {
      final model = HighlightModel.fromEntity(highlight);

      await localDataSource.saveHighlight(model);

      try {
        final savedHighlight = await remoteDataSource.saveHighlight(model);
        // Delete old local highlight (with temp ID) and save new one (with server ID)
        if (model.id != savedHighlight.id) {
          await localDataSource.deleteHighlight(model.id);
        }
        await localDataSource.saveHighlight(savedHighlight);
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

      await localDataSource.updateHighlight(model);

      try {
        final updatedHighlight = await remoteDataSource.updateHighlight(model);
        await localDataSource.updateHighlight(updatedHighlight);
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
  Future<Either<Failure, Highlight>> addHighlightNote(
    HighlightNoteParams params,
  ) async {
    try {
      final currentHighlight = await _getLocalHighlight(
        params.paperId,
        params.highlightId,
      );
      final updatedLocal = currentHighlight.copyWith(note: params.note);
      await localDataSource.updateHighlight(
        HighlightModel.fromEntity(updatedLocal),
      );

      try {
        final updatedHighlight = await remoteDataSource.addHighlightNote(
          paperId: params.paperId,
          highlightId: params.highlightId,
          note: params.note,
        );
        await localDataSource.updateHighlight(updatedHighlight);
        return Right(updatedHighlight);
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote add note failed, using local: $e',
        );
        return Right(updatedLocal);
      }
    } catch (e) {
      MyLogger.error('[AnnotationRepository] Error adding highlight note: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Highlight>> updateHighlightNote(
    HighlightNoteParams params,
  ) async {
    try {
      final currentHighlight = await _getLocalHighlight(
        params.paperId,
        params.highlightId,
      );
      final updatedLocal = currentHighlight.copyWith(note: params.note);
      await localDataSource.updateHighlight(
        HighlightModel.fromEntity(updatedLocal),
      );

      try {
        final updatedHighlight = await remoteDataSource.updateHighlightNote(
          paperId: params.paperId,
          highlightId: params.highlightId,
          note: params.note,
        );
        await localDataSource.updateHighlight(updatedHighlight);
        return Right(updatedHighlight);
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote update note failed, using local: $e',
        );
        return Right(updatedLocal);
      }
    } catch (e) {
      MyLogger.error(
        '[AnnotationRepository] Error updating highlight note: $e',
      );
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteHighlight(String highlightId) async {
    try {
      final highlight = await _getLocalHighlightById(highlightId);

      await localDataSource.deleteHighlight(highlightId);

      try {
        await remoteDataSource.deleteHighlight(highlight.paperId, highlightId);
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

  @override
  Future<Either<Failure, void>> deleteHighlightNote(
    HighlightNoteParams params,
  ) async {
    try {
      final currentHighlight = await _getLocalHighlight(
        params.paperId,
        params.highlightId,
      );
      final updatedLocal = currentHighlight.copyWith(note: '');
      await localDataSource.updateHighlight(
        HighlightModel.fromEntity(updatedLocal),
      );

      try {
        await remoteDataSource.deleteHighlightNote(
          paperId: params.paperId,
          highlightId: params.highlightId,
        );
      } catch (e) {
        MyLogger.warning(
          '[AnnotationRepository] Remote delete note failed, local updated: $e',
        );
      }

      return const Right(null);
    } catch (e) {
      MyLogger.error(
        '[AnnotationRepository] Error deleting highlight note: $e',
      );
      return Left(CacheFailure());
    }
  }

  Future<Highlight> _getLocalHighlight(
    String paperId,
    String highlightId,
  ) async {
    final highlights = await localDataSource.getHighlights(paperId);
    return highlights.firstWhere((highlight) => highlight.id == highlightId);
  }

  Future<Highlight> _getLocalHighlightById(String highlightId) async {
    final highlight = await localDataSource.getHighlightById(highlightId);
    if (highlight == null) {
      throw Exception('Highlight not found');
    }
    return highlight;
  }
}
