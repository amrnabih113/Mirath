import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entites/highlight_entity.dart';
import '../entites/highlight_note_params.dart';
import '../entites/paper_highlights_params.dart';

abstract class AnnotationRepository {
  /// Get all highlights for a specific paper
  Future<Either<Failure, List<Highlight>>> getHighlights(String paperId);

  /// Get all highlights with notes for a specific paper
  Future<Either<Failure, List<Highlight>>> getAnnotatedHighlights(
    PaperHighlightsParams params,
  );

  /// Save a new highlight
  Future<Either<Failure, Highlight>> saveHighlight(Highlight highlight);

  /// Update an existing highlight (color, note)
  Future<Either<Failure, Highlight>> updateHighlight(Highlight highlight);

  /// Add a note to an existing highlight
  Future<Either<Failure, Highlight>> addHighlightNote(
    HighlightNoteParams params,
  );

  /// Update an existing highlight note
  Future<Either<Failure, Highlight>> updateHighlightNote(
    HighlightNoteParams params,
  );

  /// Delete a highlight
  Future<Either<Failure, void>> deleteHighlight(String highlightId);

  /// Delete a note from a highlight
  Future<Either<Failure, void>> deleteHighlightNote(HighlightNoteParams params);

  /// Summarize a text
  Future<Either<Failure, String>> summarizeText({
    required String paperId,
    required String text,
  });

  /// Explain a text
  Future<Either<Failure, String>> explainText({
    required String paperId,
    required String text,
  });

  /// Translate a text
  Future<Either<Failure, String>> translateText({
    required String paperId,
    required String text,
    required String targetLanguage,
  });
}
