import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/my_logger.dart';

import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/sync/retry_service.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/upload_files_params.dart';
import '../../domain/entities/submit_feedback_params.dart';

import '../../domain/usecases/create_session_usecase.dart';
import '../../domain/usecases/create_temporary_session_usecase.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_session_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/stream_messages_usecase.dart';
import '../../domain/usecases/upload_files_usecase.dart';
import '../../domain/usecases/submit_feedback_usecase.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit({
    required this.uploadFilesUseCase,
    required this.createSessionUseCase,
    required this.createTemporarySessionUseCase,
    required this.getSessionMessagesUseCase,
    required this.sendMessageUseCase,
    required this.streamMessagesUseCase,
    required this.submitFeedbackUseCase,
    required this.cacheService,
    required this.retryService,
    required this.networkManager,
  }) : super(const ChatbotInitial());

  final UploadFilesUseCase uploadFilesUseCase;
  final CreateSessionUseCase createSessionUseCase;
  final CreateTemporarySessionUseCase createTemporarySessionUseCase;
  final GetSessionMessagesUseCase getSessionMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StreamMessagesUseCase streamMessagesUseCase;
  final SubmitFeedbackUseCase submitFeedbackUseCase;
  final HiveCacheService
  cacheService; 
  final RetryService retryService;
  final NetworkManager networkManager;

  final List<ChatMessage> _messages = [];
  StreamSubscription<String>? _sseSub;
  final Map<String, CancelToken> _uploadCancelTokens = {};
  String? _currentSessionId;
  bool _isTemporaryChat = false;

  String? get currentSessionId => _currentSessionId;
  bool get isTemporaryChat => _isTemporaryChat;

  void _emitLoaded() {
    emit(
      ChatbotLoaded(
        messages: List.from(_messages),
        currentSessionId: _currentSessionId,
        isTemporaryChat: _isTemporaryChat,
      ),
    );
  }

  void startNewChat() {
    _isTemporaryChat = false;
    _currentSessionId = null;
    clearConversation();
  }

  Future<void> startTemporaryChat() async {
    _isTemporaryChat = true;
    _currentSessionId = null;
    clearConversation();
  }

  Future<void> loadSession(Session session) async {
    _isTemporaryChat = session.isTemporary;
    _currentSessionId = session.id;
    _sseSub?.cancel();
    _sseSub = null;
    _messages.clear();
    _emitLoaded();

    final result = await getSessionMessagesUseCase(session.id);
    result.fold(
      (failure) {
        MyLogger.error(
          '[ChatbotCubit] failed to load session ${session.id}: ${failure.toString()}',
        );
        final errMsg = ChatMessage(
          id: const Uuid().v4(),
          text: 'Failed to load chat history. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          isComplete: true,
          isPending: false,
        );
        _messages.add(errMsg);
        _emitLoaded();
      },
      (history) {
        _messages.addAll(history);
        _emitLoaded();
      },
    );
  }

  void clearConversation() {
    _sseSub?.cancel();
    _sseSub = null;
    _messages.clear();
    for (final token in _uploadCancelTokens.values) {
      if (!token.isCancelled) token.cancel('conversation_cleared');
    }
    _uploadCancelTokens.clear();
    _emitLoaded();
  }

  @override
  Future<void> close() {
    // cancel uploads
    for (final token in _uploadCancelTokens.values) {
      if (!token.isCancelled) token.cancel('cubit_closed');
    }
    _uploadCancelTokens.clear();
    _sseSub?.cancel();
    return super.close();
  }

  void cancelUpload(String localPath) {
    final token = _uploadCancelTokens.remove(localPath);
    if (token != null && !token.isCancelled) token.cancel('user_cancelled');

    final idx = _messages.indexWhere(
      (m) => m.imagePaths?.contains(localPath) ?? false,
    );
    if (idx >= 0) {
      final current = _messages[idx];
      final updated = Map<String, double>.from(current.uploadProgress ?? {});
      updated.remove(localPath);
      _messages[idx] = current.copyWith(uploadProgress: updated);
      _emitLoaded();
    }
  }

  void removeImage(int index, List<String> imagePaths) {
    imagePaths.removeAt(index);
    _emitLoaded();
  }

  Future<void> sendMessage(
    String text, {
    List<String>? imagePaths,
    File? audioFile,
    int? audioDuration,
  }) async {
    if (text.trim().isEmpty && (imagePaths == null || imagePaths.isEmpty))
      return;

    final uploadProgressMap = imagePaths != null
        ? Map<String, double>.fromEntries(
            imagePaths.map((p) => MapEntry(p, 0.0)),
          )
        : null;

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      imagePaths: imagePaths,
      uploadProgress: uploadProgressMap,
      isPending: false,
    );

    _messages.add(userMessage);
    MyLogger.info(
      '[ChatbotCubit] Optimistic user message added id=${userMessage.id} text="${userMessage.text}"',
    );
    _emitLoaded();
    final assistantPlaceholder = ChatMessage(
      id: const Uuid().v4(),
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      loadingStatus: 'Sending...',
      isComplete: false,
    );

    _messages.add(assistantPlaceholder);

    _emitLoaded();
    final clientId = userMessage.id;

    if (!await networkManager.isConnected) {
      await retryService.enqueue('send_message', {
        'conversationId': 'chatbot',
        'text': userMessage.text,
        'clientId': clientId,
      });
      MyLogger.info(
        '[ChatbotCubit] Offline — enqueued message clientId=$clientId',
      );
      return;
    }

    final List<String> fileIds = [];

    if (imagePaths != null && imagePaths.isNotEmpty) {
      for (final path in imagePaths) {
        final file = File(path);
        final token = CancelToken();
        _uploadCancelTokens[path] = token;
        MyLogger.info('[ChatbotCubit] uploading file $path');

        final uploadResult = await uploadFilesUseCase(
          UploadFilesParams(
            files: [file],
            type: 'IMAGE',
            onProgress: (sent, total) {
              final progress = total > 0 ? (sent / total) : 0.0;
              final idx = _messages.indexWhere((m) => m.id == clientId);
              if (idx >= 0) {
                final current = _messages[idx];
                final updated = Map<String, double>.from(
                  current.uploadProgress ?? {},
                );
                updated[path] = progress.clamp(0.0, 1.0);
                _messages[idx] = current.copyWith(uploadProgress: updated);
                _emitLoaded();
                MyLogger.info(
                  '[ChatbotCubit] upload progress $path ${(progress * 100).toStringAsFixed(1)}%',
                );
              }
            },
            cancelToken: token,
          ),
        );

        uploadResult.fold(
          (failure) {
            MyLogger.error(
              '[ChatbotCubit] upload failed for $path: ${failure.toString()}',
            );
          },
          (resps) {
            if (resps.isNotEmpty) fileIds.add(resps.first.id);
            final idx = _messages.indexWhere((m) => m.id == clientId);
            if (idx >= 0) {
              final current = _messages[idx];
              final updated = Map<String, double>.from(
                current.uploadProgress ?? {},
              );
              updated[path] = 1.0;
              _messages[idx] = current.copyWith(uploadProgress: updated);
              _emitLoaded();
            }
            _uploadCancelTokens.remove(path);
          },
        );
      }
    }

    // upload audio if present
    if (audioFile != null) {
      final uploadResult = await uploadFilesUseCase(
        UploadFilesParams(
          files: [audioFile],
          type: 'AUDIO',
          durationSeconds: audioDuration,
        ),
      );
      uploadResult.fold((_) {}, (resps) {
        if (resps.isNotEmpty) fileIds.add(resps.first.id);
      });
    }

    // Reuse the currently loaded session when available; otherwise create
    // a new one for this conversation.
    String sessionId = _currentSessionId ?? '';
    if (sessionId.isEmpty) {
      final res = _isTemporaryChat
          ? await createTemporarySessionUseCase(const NoParams())
          : await createSessionUseCase(const NoParams());
      final created = res.fold((_) => null, (Session? s) => s);
      if (created == null) {
        final idx = _messages.indexWhere((m) => m.id == clientId);
        if (idx >= 0) {
          final current = _messages[idx];
          _messages[idx] = current.copyWith(isPending: false);
          _emitLoaded();
        }
        final errMsg = ChatMessage(
          id: const Uuid().v4(),
          text: 'Failed to create chat session. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          isComplete: true,
          isPending: false,
        );
        _messages.add(errMsg);
        _emitLoaded();
        return;
      }
      MyLogger.info('[ChatbotCubit] createSession response: ${created.id}');
      sessionId = created.id;
      _currentSessionId = sessionId;
      _emitLoaded();
    } else {
      MyLogger.info('[ChatbotCubit] reusing existing session: $sessionId');
    }

    final trimmedText = text.trim();
    final body = <String, dynamic>{
      if (trimmedText.isNotEmpty) 'content': trimmedText,
      if (fileIds.isNotEmpty) 'fileId': fileIds.first,
    };

    MyLogger.info(
      '[ChatbotCubit] starting streaming POST to session=$sessionId body=${body.toString()}',
    );
    try {
      // Start streaming by POSTing the message body and listening to the
      // streaming response. This avoids making a separate GET which some
      // backends do not expose for SSE.
      _startSseListening(sessionId, body: body);
    } catch (e) {
      await retryService.enqueue('send_message', {
        'conversationId': 'chatbot',
        'text': userMessage.text,
        'clientId': clientId,
      });
      MyLogger.error(
        '[ChatbotCubit] sendMessage failed: ${e.toString()} — queued for retry',
      );
      final idx = _messages.indexWhere((m) => m.id == clientId);
      if (idx >= 0) {
        final current = _messages[idx];
        _messages[idx] = current.copyWith(isPending: false);
        _emitLoaded();
      }
      final errMsg = ChatMessage(
        id: const Uuid().v4(),
        text: 'Failed to send message. It was queued for retry.',
        isUser: false,
        timestamp: DateTime.now(),
        isComplete: true,
        isPending: false,
      );
      _messages.add(errMsg);
      _emitLoaded();
    }
  }

  void _startSseListening(String sessionId, {Map<String, dynamic>? body}) {
    _sseSub?.cancel();
    _sseSub = streamMessagesUseCase(sessionId, body: body).listen(
      (data) {
        MyLogger.info('[ChatbotCubit] SSE raw: $data');
        String chunk = data;
        try {
          final parsed = jsonDecode(data);
          if (parsed is Map<String, dynamic>) {
            if (parsed.containsKey('transcription')) {
              final text = parsed['transcription']?.toString() ?? '';
              if (text.isNotEmpty) {
                final messageId = const Uuid().v4();
                final tMsg = ChatMessage(
                  id: messageId,
                  text: 'Transcription: $text',
                  isUser: false,
                  timestamp: DateTime.now(),
                  isComplete: true,
                );
                _messages.add(tMsg);
                _emitLoaded();
              }
              return;
            }

            if (parsed.containsKey('error')) {
              final err = parsed['error']?.toString() ?? 'An error occurred';
              final pendingIdx = _messages.indexWhere(
                (m) => m.isUser && m.isPending,
              );
              if (pendingIdx >= 0) {
                final pending = _messages[pendingIdx];
                _messages[pendingIdx] = pending.copyWith(isPending: false);
              }
              final messageId = const Uuid().v4();
              final errMsg = ChatMessage(
                id: messageId,
                text: err,
                isUser: false,
                timestamp: DateTime.now(),
                isComplete: true,
                isError: true,
              );
              _messages.add(errMsg);
              _emitLoaded();
              return;
            }

            // Handle status events (loading states)
            if (parsed.containsKey('status')) {
              final status = parsed['status']?.toString() ?? '';
              if (status.isNotEmpty) {
                if (_messages.isEmpty || _messages.last.isUser) {
                  final messageId = const Uuid().v4();
                  final botMsg = ChatMessage(
                    id: messageId,
                    text: '',
                    isUser: false,
                    timestamp: DateTime.now(),
                    isComplete: false,
                    loadingStatus: status,
                  );
                  _messages.add(botMsg);
                } else {
                  final last = _messages.last;
                  _messages[_messages.length - 1] = last.copyWith(
                    loadingStatus: status,
                  );
                }
                _emitLoaded();
              }
              return;
            }

            // Handle delta events (response chunks)
            if (parsed.containsKey('delta')) {
              chunk = parsed['delta']?.toString() ?? '';
              // When we receive the first delta, clear the loading status
              if (chunk.isNotEmpty) {
                if (_messages.isEmpty || _messages.last.isUser) {
                  final messageId = const Uuid().v4();
                  final botMsg = ChatMessage(
                    id: messageId,
                    text: chunk,
                    isUser: false,
                    timestamp: DateTime.now(),
                    isComplete: false,
                  );
                  _messages.add(botMsg);
                } else {
                  final last = _messages.last;
                  _messages[_messages.length - 1] = last.copyWith(
                    text: (last.text.isEmpty ? '' : last.text) + chunk,
                    loadingStatus: null,
                  );
                }
                _emitLoaded();
              }
              return;
            }

            // Fallback: try other content fields
            if (parsed.containsKey('content')) {
              chunk = parsed['content']?.toString() ?? '';
            } else if (parsed.containsKey('text')) {
              chunk = parsed['text']?.toString() ?? '';
            }
          }
        } catch (_) {
          // not JSON — treat as raw chunk
        }

        final lower = chunk.toLowerCase();
        if (lower.contains('bad request') ||
            lower.contains('exception') ||
            lower.startsWith('error')) {
          final pendingIdx = _messages.indexWhere(
            (m) => m.isUser && m.isPending,
          );
          if (pendingIdx >= 0) {
            final pending = _messages[pendingIdx];
            _messages[pendingIdx] = pending.copyWith(isPending: false);
          }
          final errText = chunk.trim();
          final messageId = const Uuid().v4();
          final errMsg = ChatMessage(
            id: messageId,
            text: errText.isNotEmpty
                ? errText
                : 'An error occurred while streaming the response.',
            isUser: false,
            timestamp: DateTime.now(),
            isComplete: true,
            isError: true,
          );
          _messages.add(errMsg);
          _emitLoaded();
          return;
        }

        if (chunk.trim() == '[DONE]') {
          final pendingIdx = _messages.indexWhere(
            (m) => m.isUser && m.isPending,
          );
          if (pendingIdx >= 0) {
            final pending = _messages[pendingIdx];
            _messages[pendingIdx] = pending.copyWith(isPending: false);
          }
          if (_messages.isNotEmpty) {
            final last = _messages.last;
            _messages[_messages.length - 1] = last.copyWith(
              isComplete: true,
              isPending: false,
              loadingStatus: null,
            );
            _emitLoaded();
          }
          return;
        }

        if (chunk.isNotEmpty) {
          if (_messages.isEmpty || _messages.last.isUser) {
            final messageId = const Uuid().v4();
            final botMsg = ChatMessage(
              id: messageId,
              text: chunk,
              isUser: false,
              timestamp: DateTime.now(),
              isComplete: false,
            );
            _messages.add(botMsg);
          } else {
            final last = _messages.last;
            _messages[_messages.length - 1] = last.copyWith(
              text: last.text + chunk,
              loadingStatus: null,
            );
          }
          _emitLoaded();
        }
      },
      onError: (e) {
        final pendingIdx = _messages.indexWhere((m) => m.isUser && m.isPending);
        if (pendingIdx >= 0) {
          final pending = _messages[pendingIdx];
          _messages[pendingIdx] = pending.copyWith(isPending: false);
        }
        _emitLoaded();
        emit(ChatbotError(message: e.toString()));
      },
    );
  }

  Future<void> submitFeedback(
    String messageId,
    String feedbackType,
  ) async {
    if (_currentSessionId == null || _currentSessionId!.isEmpty) {
      MyLogger.error('[ChatbotCubit] submitFeedback: no session ID available');
      return;
    }

    try {
      // Update UI to show loading state
      final idx = _messages.indexWhere((m) => m.id == messageId);
      if (idx >= 0) {
        final current = _messages[idx];
        _messages[idx] = current.copyWith(isFeedbackSubmitting: true);
        _emitLoaded();
      }

      MyLogger.info(
        '[ChatbotCubit] submitFeedback: messageId=$messageId, feedbackType=$feedbackType',
      );

      final params = SubmitFeedbackParams(
        sessionId: _currentSessionId!,
        messageId: messageId,
        feedbackType: feedbackType,
      );

      final result = await submitFeedbackUseCase(params);

      result.fold(
        (failure) {
          MyLogger.error(
            '[ChatbotCubit] submitFeedback failed: ${failure.toString()}',
          );
          // Update UI to show error state
          if (idx >= 0) {
            final current = _messages[idx];
            _messages[idx] = current.copyWith(isFeedbackSubmitting: false);
            _emitLoaded();
          }
        },
        (feedback) {
          MyLogger.info(
            '[ChatbotCubit] feedback submitted successfully: ${feedback.type}',
          );
          // Update UI to show success state
          if (idx >= 0) {
            final current = _messages[idx];
            _messages[idx] = current.copyWith(
              userFeedback: feedback.type,
              isFeedbackSubmitting: false,
            );
            _emitLoaded();
          }
        },
      );
    } catch (e) {
      MyLogger.error('[ChatbotCubit] submitFeedback error: ${e.toString()}');
      // Update UI to reset loading state
      final idx = _messages.indexWhere((m) => m.id == messageId);
      if (idx >= 0) {
        final current = _messages[idx];
        _messages[idx] = current.copyWith(isFeedbackSubmitting: false);
        _emitLoaded();
      }
    }
  }
}
