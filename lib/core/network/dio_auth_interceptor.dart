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
  Completer<String?>? _refreshCompleter;

  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(seconds: 1);
  static const Duration _refreshTimeout = Duration(seconds: 30);

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
    // Skip auth header for refresh requests
    if (options.extra['skipAuth'] == true ||
        options.path.contains(MyConstants.refreshToken)) {
      options.headers.remove('Authorization');
      return handler.next(options);
    }

    final token = await secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Do not retry refresh endpoint itself
    if (err.requestOptions.path.contains(MyConstants.refreshToken)) {
      await _handleAuthFailure();
      return handler.next(err);
    }

    MyLogger.info('[AuthInterceptor] 401 → refreshing token');

    try {
      final newToken = await _refreshTokenWithRetry();

      if (newToken == null) {
        await _handleAuthFailure();
        return handler.next(err);
      }

      // Retry original request with new token
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      MyLogger.error('[AuthInterceptor] Refresh failed: $e');
      await _handleAuthFailure();
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
      String? result;

      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        try {
          MyLogger.info(
            '[AuthInterceptor] Refresh attempt $attempt/$_maxRetries',
          );

          // Use same Dio instance to send cookies
          final response = await dio.post(
            MyConstants.refreshToken,
            options: Options(
              headers: {'Authorization': null}, // Do NOT send access token
              extra: {'skipAuth': true}, // skip interceptor auth logic
              sendTimeout: _refreshTimeout,
              receiveTimeout: _refreshTimeout,
            ),
          );

          final newAccessToken = response.data['accessToken'] as String?;

          if (newAccessToken != null) {
            await secureStorage.saveAccessToken(newAccessToken);
            result = newAccessToken;
            break;
          } else {
            result = null;
            break;
          }
        } on DioException catch (e) {
          if (_isNetworkError(e) && attempt < _maxRetries) {
            final delay = _initialRetryDelay * attempt * 2;
            await Future.delayed(delay);
            continue;
          }
          result = null;
          break;
        }
      }

      _refreshCompleter!.complete(result);
      return result;
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
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        return code != null && code >= 500;
      default:
        return false;
    }
  }

  Future<void> _handleAuthFailure() async {
    MyLogger.warning('[AuthInterceptor] Auth failure → clearing tokens');
    await secureStorage.clearTokens();
    await secureStorage.clearEmail();
    onAuthFailure?.call();
  }
}
