import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mirath/features/chatbot/data/models/feedback_model.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_logger.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/chatbot_message_model.dart';
import '../models/file_upload_response.dart';
import '../models/session_model.dart';
import 'chatbot_remote_data_source.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final DioClient dioClient;

  ChatbotRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<FileUploadResponse> uploadFile(
    File file,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'type': type,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
    });

    final resp = await dioClient.post(
      MyConstants.chatbotUploadFile,
      data: form,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      onSendProgress: onProgress,
      cancelToken: cancelToken,
    );

    final data = resp.data as Map<String, dynamic>;
    return FileUploadResponse.fromJson(data);
  }

  @override
  Future<List<FileUploadResponse>> uploadFiles(
    List<File> files,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final results = <FileUploadResponse>[];
    // For multi-file uploads, call uploadFile for each and forward per-file progress.
    for (final file in files) {
      final resp = await uploadFile(
        file,
        type,
        durationSeconds: durationSeconds,
        onProgress: onProgress,
        cancelToken: cancelToken,
      );
      results.add(resp);
    }
    return results;
  }

  @override
  Future<SessionModel> createTemporarySession() async {
    final resp = await dioClient.post(
      MyConstants.chatbotCreateTemporarySession,
    );
    final data = resp.data as Map<String, dynamic>;
    return SessionModel.fromJson(data);
  }

  @override
  Future<void> deleteTemporarySession(String id) async {
    final path = MyConstants.chatbotDeleteTemporarySession.replaceAll(
      '{id}',
      id,
    );
    await dioClient.delete(path);
  }

  @override
  Future<SessionModel> createSession() async {
    final resp = await dioClient.post(MyConstants.chatbotCreateSession);
    final data = resp.data as Map<String, dynamic>;
    return SessionModel.fromJson(data);
  }

  @override
  Future<List<SessionModel>> getSessions({int page = 1, int limit = 20}) async {
    final resp = await dioClient.get(
      MyConstants.chatbotGetSessions,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = resp.data as Map<String, dynamic>;
    final list = (data['data'] as List?) ?? (data['items'] as List?) ?? [];
    return list
        .map((e) => SessionModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<SessionModel> getSessionById(String id) async {
    final path = MyConstants.chatbotGetSessionById.replaceAll('{id}', id);
    final resp = await dioClient.get(path);
    final data = resp.data as Map<String, dynamic>;
    return SessionModel.fromJson(data);
  }

  @override
  Future<List<ChatbotMessageModel>> getSessionMessages(String sessionId) async {
    final path = MyConstants.chatbotGetHistory.replaceAll('{id}', sessionId);
    final resp = await dioClient.get(path);
    final data = resp.data as Map<String, dynamic>;
    final list = (data['data'] as List?) ?? (data['items'] as List?) ?? [];
    return list
        .map(
          (e) =>
              ChatbotMessageModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<void> deleteSession(String id) async {
    final path = MyConstants.chatbotDeleteSession.replaceAll('{id}', id);
    await dioClient.delete(path);
  }

  @override
  Future<Map<String, dynamic>> sendMessage(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    if (sessionId.trim().isEmpty) {
      MyLogger.error('[ChatbotRemote] sendMessage called with empty sessionId');
      throw ArgumentError('sessionId is empty');
    }
    final path = MyConstants.chatbotSendMessage.replaceAll('{id}', sessionId);
    MyLogger.info('[ChatbotRemote] POST $path body=${body.toString()}');
    final resp = await dioClient.post(path, data: body);

    final contentType = resp.headers.value(Headers.contentTypeHeader) ?? '';
    final returned = resp.data;

    // If server returned an SSE stream (text/event-stream) the body may be
    // plain text chunks; treat that as a streaming response and return an
    // empty map so callers can rely on the stream endpoint instead.
    if (contentType.contains('text/event-stream') ||
        (returned is String &&
            (returned.trim().startsWith('data:') ||
                returned.trim().startsWith('id:')))) {
      MyLogger.info(
        '[ChatbotRemote] sendMessage returned stream content; treating as streaming response',
      );
      return <String, dynamic>{};
    }

    // If response is already a map, return it. If it's a JSON string, try to parse.
    if (returned is Map<String, dynamic>) {
      return returned;
    }

    if (returned is String) {
      try {
        final parsed = jsonDecode(returned);
        if (parsed is Map<String, dynamic>) return parsed;
      } catch (_) {
        // not JSON — fall through
        MyLogger.error('[ChatbotRemote] sendMessage response is not valid JSON');
      }
    }

    // Fallback: return empty map to indicate no immediate JSON response.
    MyLogger.info(
      '[ChatbotRemote] sendMessage response is not JSON/map; returning empty map',
    );
    return <String, dynamic>{};
  }

  @override
  Stream<String> streamSessionMessages(
    String sessionId, {
    Map<String, String>? extraHeaders,
    Map<String, dynamic>? body,
  }) async* {
    final path = MyConstants.chatbotSendMessage.replaceAll('{id}', sessionId);

    // Accept streaming response. Some servers implement SSE as the response
    // to a POST (when you POST a message and immediately stream the reply),
    // while others expose a GET endpoint. Try POST-first and fall back to GET
    // if POST is not available (404).
    final options = Options(
      responseType: ResponseType.stream,
      headers: {'Accept': 'text/event-stream', ...?extraHeaders},
    );

    Response<ResponseBody>? response;

    try {
      // Try POST first (works for servers that stream the POST response)
      try {
        response = await dioClient.dio.post<ResponseBody>(
          path,
          data: body,
          options: options,
        );
      } catch (e) {
        // If POST returned 404, try GET as a fallback exactly once.
        if (e is DioError && e.response?.statusCode == 404) {
          response = await dioClient.dio.get<ResponseBody>(
            path,
            options: options,
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      yield* Stream.error(e);
      return;
    }

    final stream = response.data!.stream;
    final utf8Decoder = const Utf8Decoder();
    final buffer = StringBuffer();
    var remoteClosed = false;

    try {
      await for (final chunk in stream) {
        final part = utf8Decoder.convert(chunk);
        buffer.write(part);

        var content = buffer.toString();
        while (content.contains('\n\n')) {
          final splitIndex = content.indexOf('\n\n');
          final event = content.substring(0, splitIndex).trim();
          content = content.substring(splitIndex + 2);
          final lines = event.split('\n');
          final dataLines = lines.where((l) => l.startsWith('data:')).toList();
          final data = dataLines.map((l) => l.substring(5).trim()).join('\n');
          if (data.isNotEmpty) {
            yield data;
            if (data.trim() == '[DONE]') {
              remoteClosed = true;
              break;
            }
          }
        }
        buffer.clear();
        buffer.write(content);
        if (remoteClosed) break;
      }
    } catch (e) {
      yield* Stream.error(e);
      return;
    }

    if (remoteClosed) return;
  }

  @override
  Future<FeedbackModel> submitFeedback(
    String sessionId,
    String messageId,
    String feedbackType,
  ) async {
    final path = MyConstants.chatbotSubmitFeedback
        .replaceAll('{sessionId}', sessionId)
        .replaceAll('{messageId}', messageId);
    
    final body = {'feedbackType': feedbackType};
    final resp = await dioClient.post(path, data: body);
    
    final data = resp.data as Map<String, dynamic>;
    final feedbackData = data['data'] as Map<String, dynamic>?;
    
    if (feedbackData == null) {
      throw StateError('Invalid feedback response: no data field');
    }
    
    return FeedbackModel.fromJson(feedbackData);
  }
}
