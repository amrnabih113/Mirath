import '../models/highlight_model.dart';

/// Remote data source for annotations (Backend API)
abstract class AnnotationRemoteDataSource {
  /// Get all highlights for a paper from the server
  Future<List<HighlightModel>> getHighlights(String paperId);

  /// Save a highlight to the server
  Future<HighlightModel> saveHighlight(HighlightModel highlight);

  /// Update a highlight on the server
  Future<HighlightModel> updateHighlight(HighlightModel highlight);

  /// Delete a highlight from the server
  Future<void> deleteHighlight(String highlightId);
}
