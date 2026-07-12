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

  @override
  Future<String> explainText({
    required String paperId,
    required String text,
  }) async {
    final response = await dioClient.post(
      MyConstants.paperAnnotationExplanation.replaceAll('{id}', paperId),
      data: {'selectedText': text},
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return data['answer'] as String;
      }
    }
    throw const FormatException('Unable to parse explain text response');
  }

  @override
  Future<String> summarizeText({
    required String paperId,
    required String text,
  }) async {
    return await dioClient
        .post(
          MyConstants.paperAnnotationSummarization.replaceAll('{id}', paperId),
          data: {'selectedText': text},
        )
        .then((response) {
          if (response.data is Map<String, dynamic>) {
            final data = response.data['data'];
            if (data is Map<String, dynamic>) {
              return data['answer'] as String;
            }
          }
          throw const FormatException(
            'Unable to parse summarize text response',
          );
        });
  }

  @override
  Future<String> translateText({
    required String paperId,
    required String text,
    required String targetLanguage,
  }) async {
    return await dioClient
        .post(
          MyConstants.paperAnnotationTranslation.replaceAll('{id}', paperId),
          data: {'selectedText': text, 'targetLanguage': targetLanguage},
        )
        .then((response) {
          if (response.data is Map<String, dynamic>) {
            final data = response.data['data'];
            if (data is Map<String, dynamic>) {
              return data['answer'] as String;
            }
          }
          throw const FormatException(
            'Unable to parse translate text response',
          );
        });
  }
}
