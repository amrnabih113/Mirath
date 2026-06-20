import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/session.dart';
import '../data_sources/chatbot_remote_data_source.dart';
import '../models/file_upload_response.dart';
import '../../../../core/cache/cache_keys.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;
  final NetworkManager networkManager;
  final HiveCacheService cacheService;

  ChatbotRepositoryImpl({
    required this.remoteDataSource,
    required this.networkManager,
    required this.cacheService,
  });

  @override
  Future<Either<Failure, FileUploadResponse>> uploadFile(
    File file,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      if (await networkManager.isConnected) {
        MyLogger.info(
          '[ChatbotRepository] uploadFile -> remoteDataSource.uploadFile for ${file.path}',
        );
        final resp = await remoteDataSource.uploadFile(
          file,
          type,
          durationSeconds: durationSeconds,
          onProgress: onProgress,
          cancelToken: cancelToken,
        );
        return Right(resp);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FileUploadResponse>>> uploadFiles(
    List<File> files,
    String type, {
    int? durationSeconds,
    void Function(int, int)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      if (await networkManager.isConnected) {
        MyLogger.info(
          '[ChatbotRepository] uploadFiles -> remoteDataSource.uploadFiles for ${files.length} files',
        );
        final resp = await remoteDataSource.uploadFiles(
          files,
          type,
          durationSeconds: durationSeconds,
          onProgress: onProgress,
          cancelToken: cancelToken,
        );
        return Right(resp);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Session>> createTemporarySession() async {
    try {
      if (await networkManager.isConnected) {
        final model = await remoteDataSource.createTemporarySession();
        return Right(model.toEntity());
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemporarySession(String id) async {
    try {
      if (await networkManager.isConnected) {
        await remoteDataSource.deleteTemporarySession(id);
        return const Right(null);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Session>> createSession() async {
    try {
      if (await networkManager.isConnected) {
        final model = await remoteDataSource.createSession();
        final session = model.toEntity();
        return Right(session);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getSessions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (await networkManager.isConnected) {
        final resp = await remoteDataSource.getSessions(
          page: page,
          limit: limit,
        );
        final list = resp.map((e) => e.toEntity()).toList();
        return Right(list);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Session>> getSessionById(String id) async {
    try {
      if (await networkManager.isConnected) {
        final model = await remoteDataSource.getSessionById(id);
        return Right(model.toEntity());
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getSessionMessages(
    String sessionId,
  ) async {
    try {
      if (await networkManager.isConnected) {
        final models = await remoteDataSource.getSessionMessages(sessionId);
        final messages = models.map((model) => model.toEntity()).toList();
        return Right(messages);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      if (await networkManager.isConnected) {
        await remoteDataSource.deleteSession(id);
        return const Right(null);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    try {
      if (await networkManager.isConnected) {
        final resp = await remoteDataSource.sendMessage(sessionId, body);
        // Optionally cache the sent message under conversation key
        final convoKey = CacheKeys.messages(sessionId);
        if (resp.isNotEmpty) {
          await cacheService.upsertInJsonList(
            key: convoKey,
            item: resp,
            idField: 'id',
          );
        }
        return Right(resp);
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Stream<String> streamMessages(
    String sessionId, {
    Map<String, String>? extraHeaders,
    Map<String, dynamic>? body,
  }) {
    try {
      return remoteDataSource.streamSessionMessages(
        sessionId,
        extraHeaders: extraHeaders,
        body: body,
      );
    } catch (e) {
      return Stream.error(mapExceptionToFailure(e));
    }
  }
}
