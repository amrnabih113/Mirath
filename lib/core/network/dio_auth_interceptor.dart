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
    // Skip auth for refresh requests
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
    // Prevent recursive auth failure handling - if we're already handling one,
    // just pass the error through without attempting refresh
    if (_isHandlingAuthFailure) {
      MyLogger.warning('[AuthInterceptor] Already handling auth failure, skipping retry');
      return handler.next(err);
    }

    // Skip auth handling for:
    // 1. Endpoints marked skipAuth
    // 2. Already-failed refresh attempts
    // 3. Logout endpoint
    // 4. checkSetup endpoint (to prevent 401 from triggering refresh loop)
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

    MyLogger.info('[AuthInterceptor] 401 → refreshing token via cookie');

    try {
      final newToken = await _refreshTokenWithRetry();

      if (newToken == null) {
        await _handleAuthFailure();
        return handler.next(err);
      }

      // Retry original request with new access token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newToken';
      final response = await dio.fetch(options);
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
              headers: {'Content-Type': 'application/json'},
              extra: {'skipAuth': true},
            ),
          );

          final responseData = response.data is Map ? response.data : {};
          final data = responseData['data'] is Map ? responseData['data'] : {};
          newAccessToken = data['accessToken'] as String?;

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await secureStorage.saveAccessToken(newAccessToken);
            break;
          } else {
            newAccessToken = null;
            break;
          }
        } on DioException catch (e) {
          if (_isNetworkError(e) && attempt < _maxRetries) {
            final delay = _initialRetryDelay * attempt * 2;
            await Future.delayed(delay);
            continue;
          }
          newAccessToken = null;
          break;
        }
      }

      _refreshCompleter!.complete(newAccessToken);
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
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        return code != null && code >= 500;
      default:
        return false;
    }
  }

  Future<void> _handleAuthFailure() async {
    if (_isHandlingAuthFailure) {
      MyLogger.warning('[AuthInterceptor] Auth failure already in progress, skipping');
      return;
    }

    _isHandlingAuthFailure = true;
    try {
      MyLogger.warning('[AuthInterceptor] Auth failure → clearing tokens');
      await secureStorage.clearTokens();
      await secureStorage.clearEmail();
      onAuthFailure?.call();
    } finally {
      // Reset flag after a short delay to allow onAuthFailure callback to complete
      await Future.delayed(const Duration(milliseconds: 500));
      _isHandlingAuthFailure = false;
    }
  }
}
