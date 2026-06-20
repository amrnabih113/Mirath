import 'dart:io';

import 'package:dio/dio.dart';

import '../models/file_upload_response.dart';
import '../models/chatbot_message_model.dart';
import '../models/session_model.dart';

abstract class ChatbotRemoteDataSource {
  Future<FileUploadResponse> uploadFile(
    File file,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  });

  Future<List<FileUploadResponse>> uploadFiles(
    List<File> files,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  });

  Future<SessionModel> createTemporarySession();

  Future<void> deleteTemporarySession(String id);

  Future<SessionModel> createSession();

  Future<List<SessionModel>> getSessions({int page = 1, int limit = 20});

  Future<SessionModel> getSessionById(String id);

  Future<List<ChatbotMessageModel>> getSessionMessages(String sessionId);

  Future<void> deleteSession(String id);

  Future<Map<String, dynamic>> sendMessage(
    String sessionId,
    Map<String, dynamic> body,
  );

  /// Open an SSE stream for a session and emit raw event data strings.
  /// If `body` is provided, the implementation should POST the `body`
  /// to the messages endpoint and parse the streaming response (some
  /// backends stream the response to the POST request that creates the
  /// message). If `body` is omitted, a GET (or fallback) may be used.
  Stream<String> streamSessionMessages(
    String sessionId, {
    Map<String, String>? extraHeaders,
    Map<String, dynamic>? body,
  });
}
