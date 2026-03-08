import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import '../entites/highlight_entity.dart';

abstract class AnnotationRepository {
  /// Get all highlights for a specific paper
  Future<Either<Failure, List<Highlight>>> getHighlights(String paperId);

  /// Save a new highlight
  Future<Either<Failure, Highlight>> saveHighlight(Highlight highlight);

  /// Update an existing highlight (color, note)
  Future<Either<Failure, Highlight>> updateHighlight(Highlight highlight);

  /// Delete a highlight
  Future<Either<Failure, void>> deleteHighlight(String highlightId);
}
