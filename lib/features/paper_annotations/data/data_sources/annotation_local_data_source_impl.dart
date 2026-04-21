import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/highlight_model.dart';
import 'annotation_local_data_source.dart';

class AnnotationLocalDataSourceImpl implements AnnotationLocalDataSource {
  final SharedPreferences sharedPreferences;

  AnnotationLocalDataSourceImpl({required this.sharedPreferences});

  String _getStorageKey(String paperId) => 'paper_annotations_$paperId';

  @override
  Future<List<HighlightModel>> getHighlights(String paperId) async {
    try {
      final jsonString = sharedPreferences.getString(_getStorageKey(paperId));
      if (jsonString == null || jsonString.isEmpty) {
        return const <HighlightModel>[];
      }

      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((e) => HighlightModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return const <HighlightModel>[];
    }
  }

  @override
  Future<HighlightModel> saveHighlight(HighlightModel highlight) async {
    final highlights = await getHighlights(highlight.paperId);
    final updatedHighlights = [...highlights, highlight];
    await _persistHighlights(highlight.paperId, updatedHighlights);
    return highlight;
  }

  @override
  Future<HighlightModel> updateHighlight(HighlightModel highlight) async {
    final highlights = await getHighlights(highlight.paperId);
    final index = highlights.indexWhere((h) => h.id == highlight.id);

    if (index == -1) {
      throw Exception('Highlight not found');
    }

    final updatedHighlights = List<HighlightModel>.from(highlights);
    updatedHighlights[index] = highlight;
    await _persistHighlights(highlight.paperId, updatedHighlights);
    return highlight;
  }

  @override
  Future<void> deleteHighlight(String highlightId) async {
    // Since we need paperId to delete, we'll need to search all papers
    // For now, we'll iterate through all keys (not ideal but works for local storage)
    final allKeys = sharedPreferences.getKeys();

    for (final key in allKeys) {
      if (key.startsWith('paper_annotations_')) {
        final paperId = key.replaceFirst('paper_annotations_', '');
        final highlights = await getHighlights(paperId);
        final updatedHighlights = highlights
            .where((h) => h.id != highlightId)
            .toList();

        if (updatedHighlights.length != highlights.length) {
          await _persistHighlights(paperId, updatedHighlights);
          return;
        }
      }
    }
  }

  @override
  Future<void> clearHighlights(String paperId) async {
    await sharedPreferences.remove(_getStorageKey(paperId));
  }

  Future<void> _persistHighlights(
    String paperId,
    List<HighlightModel> highlights,
  ) async {
    final jsonString = jsonEncode(highlights.map((h) => h.toJson()).toList());
    await sharedPreferences.setString(_getStorageKey(paperId), jsonString);
  }
}
