import 'dart:async';

import 'package:dio/dio.dart';

import '../services/secure_storage_service.dart';
import '../utils/my_constants.dart';
import '../utils/my_logger.dart';

typedef OnAuthFailure = void Function();

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService secureStorage;
  final OnAuthFailure? onAuthFailure;

  bool _isRefreshing = false;
  bool _isHandlingAuthFailure = false;
  Completer<String?>? _refreshCompleter;

  static const Duration _refreshTimeout = Duration(seconds: 30);
  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(seconds: 1);

  AuthInterceptor({
    required this.dio,
    required this.secureStorage,
    this.onAuthFailure,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true ||
        options.path.contains(MyConstants.refreshToken)) {
      options.headers.remove('Authorization');
      return handler.next(options);
    }

    final token = await secureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isHandlingAuthFailure) {
      return handler.next(err);
    }

    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['skipAuth'] == true ||
        err.requestOptions.path.contains(MyConstants.logout) ||
        err.requestOptions.path.contains(MyConstants.checkSetup)) {
      return handler.next(err);
    }

    if (err.requestOptions.path.contains(MyConstants.refreshToken)) {
      await _handleAuthFailure();
      return handler.next(err);
    }

    MyLogger.info('[AuthInterceptor] 401 → refreshing access token');

    String? newToken;

    // -----------------------------
    // Refresh Token
    // -----------------------------
    try {
      newToken = await _refreshTokenWithRetry();
    } catch (e, stackTrace) {
      MyLogger.error('[AuthInterceptor] Refresh request failed$e$stackTrace');

      await _handleAuthFailure();
      return handler.next(err);
    }

    if (newToken == null) {
      MyLogger.warning('[AuthInterceptor] Refresh returned null token');

      await _handleAuthFailure();
      return handler.next(err);
    }

    // -----------------------------
    // Retry Original Request
    // -----------------------------
    try {
      final request = err.requestOptions;

      request.headers['Authorization'] = 'Bearer $newToken';

      final response = await dio.fetch(request);

      return handler.resolve(response);
    } on DioException catch (retryError, stackTrace) {
      MyLogger.error(
        '[AuthInterceptor] Retried request failed (${retryError.response?.statusCode})${retryError.message}\nRequest: ${retryError.requestOptions.method} ${retryError.requestOptions.path}',
      );

      // IMPORTANT:
      // Do NOT logout.
      // Refresh succeeded.
      // The endpoint itself failed.
      return handler.next(retryError);
    } catch (e, stackTrace) {
      MyLogger.error(
        '[AuthInterceptor] Unexpected retry error$e\nStack Trace: $stackTrace',
      );

      return handler.next(err);
    }
  }

  Future<String?> _refreshTokenWithRetry() async {
    if (_isRefreshing && _refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      String? newAccessToken;

      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        try {
          MyLogger.info(
            '[AuthInterceptor] Refresh attempt $attempt/$_maxRetries',
          );

          final response = await dio.post(
            MyConstants.refreshToken,
            options: Options(
              sendTimeout: _refreshTimeout,
              receiveTimeout: _refreshTimeout,
              headers: const {'Content-Type': 'application/json'},
              extra: {'skipAuth': true},
            ),
          );

          final responseData = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{};

          final data = responseData['data'] is Map<String, dynamic>
              ? responseData['data'] as Map<String, dynamic>
              : <String, dynamic>{};

          newAccessToken = data['accessToken'] as String?;

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await secureStorage.saveAccessToken(newAccessToken);

            MyLogger.debug(
              '[AuthInterceptor] Access token refreshed successfully',
            );

            break;
          }

          newAccessToken = null;
          break;
        } on DioException catch (e) {
          if (_isNetworkError(e) && attempt < _maxRetries) {
            final delay = Duration(
              seconds: _initialRetryDelay.inSeconds * attempt,
            );

            MyLogger.warning(
              '[AuthInterceptor] Network error during refresh. Retrying in ${delay.inSeconds}s...',
            );

            await Future.delayed(delay);
            continue;
          }

          rethrow;
        }
      }

      _refreshCompleter?.complete(newAccessToken);

      return newAccessToken;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  bool _isNetworkError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;

      default:
        return false;
    }
  }

  Future<void> _handleAuthFailure() async {
    if (_isHandlingAuthFailure) {
      return;
    }

    _isHandlingAuthFailure = true;

    try {
      MyLogger.warning(
        '[AuthInterceptor] Authentication failed → clearing session',
      );

      await secureStorage.clearTokens();
      await secureStorage.clearEmail();

      onAuthFailure?.call();
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));

      _isHandlingAuthFailure = false;
    }
  }
}
