import '../models/highlight_model.dart';

/// Remote data source for annotations (Backend API)
abstract class AnnotationRemoteDataSource {
  /// Get all highlights for a paper from the server
  Future<List<HighlightModel>> getHighlights(
    String paperId, {
    int page,
    int limit,
  });

  /// Get all highlights with notes for a paper from the server
  Future<List<HighlightModel>> getAnnotatedHighlights(
    String paperId, {
    int page,
    int limit,
  });

  /// Save a highlight to the server
  Future<HighlightModel> saveHighlight(HighlightModel highlight);

  /// Update a highlight on the server
  Future<HighlightModel> updateHighlight(HighlightModel highlight);

  /// Delete a highlight from the server
  Future<void> deleteHighlight(String paperId, String highlightId);

  /// Add a note to an existing highlight
  Future<HighlightModel> addHighlightNote({
    required String paperId,
    required String highlightId,
    required String note,
  });

  /// Update a note on an existing highlight
  Future<HighlightModel> updateHighlightNote({
    required String paperId,
    required String highlightId,
    required String note,
  });

  /// Delete a note from an existing highlight
  Future<void> deleteHighlightNote({
    required String paperId,
    required String highlightId,
  });
}
