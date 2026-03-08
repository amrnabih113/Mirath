import 'package:mirath/core/utils/my_logger.dart';
import '../models/highlight_model.dart';
import 'annotation_remote_data_source.dart';

/// Stub implementation for remote data source
/// TODO: Implement actual API calls when backend is ready
class AnnotationRemoteDataSourceImpl implements AnnotationRemoteDataSource {
  // final ApiClient apiClient;

  // AnnotationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<HighlightModel>> getHighlights(String paperId) async {
    MyLogger.info(
      '[AnnotationRemoteDataSource] TODO: Fetch highlights from backend for paper: $paperId',
    );
    // TODO: Implement API call
    // final response = await apiClient.get('/papers/$paperId/highlights');
    // return (response['data'] as List).map((e) => HighlightModel.fromJson(e)).toList();
    return [];
  }

  @override
  Future<HighlightModel> saveHighlight(HighlightModel highlight) async {
    MyLogger.info(
      '[AnnotationRemoteDataSource] TODO: Save highlight to backend: ${highlight.id}',
    );
    // TODO: Implement API call
    // final response = await apiClient.post('/highlights', body: highlight.toJson());
    // return HighlightModel.fromJson(response['data']);
    return highlight;
  }

  @override
  Future<HighlightModel> updateHighlight(HighlightModel highlight) async {
    MyLogger.info(
      '[AnnotationRemoteDataSource] TODO: Update highlight on backend: ${highlight.id}',
    );
    // TODO: Implement API call
    // final response = await apiClient.put('/highlights/${highlight.id}', body: highlight.toJson());
    // return HighlightModel.fromJson(response['data']);
    return highlight;
  }

  @override
  Future<void> deleteHighlight(String highlightId) async {
    MyLogger.info(
      '[AnnotationRemoteDataSource] TODO: Delete highlight from backend: $highlightId',
    );
    // TODO: Implement API call
    // await apiClient.delete('/highlights/$highlightId');
  }
}
