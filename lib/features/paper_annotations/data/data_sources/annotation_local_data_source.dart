import '../models/highlight_model.dart';

/// Local data source for annotations (SharedPreferences for caching/testing)
abstract class AnnotationLocalDataSource {
  /// Get all highlights for a paper from local storage
  Future<List<HighlightModel>> getHighlights(String paperId);

  /// Save a highlight to local storage
  Future<HighlightModel> saveHighlight(HighlightModel highlight);

  /// Update a highlight in local storage
  Future<HighlightModel> updateHighlight(HighlightModel highlight);

  /// Delete a highlight from local storage
  Future<void> deleteHighlight(String highlightId);

  /// Find a highlight by id across cached papers
  Future<HighlightModel?> getHighlightById(String highlightId);

  /// Clear all highlights for a paper
  Future<void> clearHighlights(String paperId);
}
