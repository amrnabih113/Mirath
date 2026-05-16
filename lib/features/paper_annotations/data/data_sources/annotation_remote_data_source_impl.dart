import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/highlight_model.dart';
import '../models/paper_highlights_response.dart';
import 'annotation_remote_data_source.dart';

class AnnotationRemoteDataSourceImpl implements AnnotationRemoteDataSource {
  final DioClient dioClient;

  AnnotationRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<HighlightModel>> getHighlights(
    String paperId, {
    int page = 1,
    int limit = 50,
  }) async {
    final response = await dioClient.get(
      MyConstants.paperHighlights.replaceAll('{id}', paperId),
      queryParameters: {'page': page, 'limit': limit},
    );

    return PaperHighlightsResponse.fromJson(
      response.data as Map<String, dynamic>,
    ).data;
  }

  @override
  Future<List<HighlightModel>> getAnnotatedHighlights(
    String paperId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dioClient.get(
      MyConstants.paperHighlightsNotes.replaceAll('{id}', paperId),
      queryParameters: {'page': page, 'limit': limit},
    );

    return PaperHighlightsResponse.fromJson(
      response.data as Map<String, dynamic>,
    ).data;
  }

  @override
  Future<HighlightModel> saveHighlight(HighlightModel highlight) async {
    final response = await dioClient.post(
      MyConstants.paperHighlights.replaceAll('{id}', highlight.paperId),
      data: highlight.toCreateJson(),
    );

    return _extractHighlight(response.data);
  }

  @override
  Future<HighlightModel> updateHighlight(HighlightModel highlight) async {
    final response = await dioClient.patch(
      MyConstants.paperHighlightById
          .replaceAll('{id}', highlight.paperId)
          .replaceAll('{highlightId}', highlight.id),
      data: highlight.toColorUpdateJson(),
    );

    return _extractHighlight(response.data);
  }

  @override
  Future<void> deleteHighlight(String paperId, String highlightId) async {
    await dioClient.delete(
      MyConstants.paperHighlightById
          .replaceAll('{id}', paperId)
          .replaceAll('{highlightId}', highlightId),
    );
  }

  @override
  Future<HighlightModel> addHighlightNote({
    required String paperId,
    required String highlightId,
    required String note,
  }) async {
    final response = await dioClient.post(
      MyConstants.paperHighlightNote
          .replaceAll('{id}', paperId)
          .replaceAll('{highlightId}', highlightId),
      data: {'note': note},
    );

    return _extractHighlight(response.data);
  }

  @override
  Future<HighlightModel> updateHighlightNote({
    required String paperId,
    required String highlightId,
    required String note,
  }) async {
    final response = await dioClient.patch(
      MyConstants.paperHighlightNote
          .replaceAll('{id}', paperId)
          .replaceAll('{highlightId}', highlightId),
      data: {'note': note},
    );

    return _extractHighlight(response.data);
  }

  @override
  Future<void> deleteHighlightNote({
    required String paperId,
    required String highlightId,
  }) async {
    await dioClient.delete(
      MyConstants.paperHighlightNote
          .replaceAll('{id}', paperId)
          .replaceAll('{highlightId}', highlightId),
    );
  }

  HighlightModel _extractHighlight(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        return HighlightModel.fromJson(data);
      }
      return HighlightModel.fromJson(responseData);
    }

    throw const FormatException('Unable to parse highlight response');
  }
}
