import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/session.dart';
import '../entities/chat_message.dart';

import '../../../../core/error/failuors.dart';
import '../../data/models/file_upload_response.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, FileUploadResponse>> uploadFile(
    File file,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, List<FileUploadResponse>>> uploadFiles(
    List<File> files,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Session>> createTemporarySession();

  Future<Either<Failure, void>> deleteTemporarySession(String id);

  Future<Either<Failure, Session>> createSession();

  Future<Either<Failure, List<Session>>> getSessions({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, Session>> getSessionById(String id);

  Future<Either<Failure, List<ChatMessage>>> getSessionMessages(
    String sessionId,
  );

  Future<Either<Failure, void>> deleteSession(String id);

  /// Sends a chat message. For streaming responses, the implementation may
  /// expose streaming helpers; here we return the server response as a map.
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(
    String sessionId,
    Map<String, dynamic> body,
  );

  /// Stream of SSE message payloads from the server for the given session.
  Stream<String> streamMessages(
    String sessionId, {
    Map<String, String>? extraHeaders,
    Map<String, dynamic>? body,
  });
}
