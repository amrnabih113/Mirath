import 'dart:async';

import 'package:dio/dio.dart';

import '../services/secure_storage_service.dart';
import '../utils/my_constants.dart';
import '../utils/my_logger.dart';

/// Callback type for notifying when authentication fails and user should be logged out
typedef OnAuthFailure = void Function();

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService secureStorage;
  final OnAuthFailure? onAuthFailure;

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  // Retry configuration
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
    // Skip auth header for refresh token endpoint
    if (options.path == MyConstants.refreshToken) {
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
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Don't retry refresh token endpoint itself
    if (err.requestOptions.path == MyConstants.refreshToken) {
      await _handleAuthFailure();
      return handler.next(err);
    }

    MyLogger.info(
      '[AuthInterceptor] 401 received, attempting token refresh...',
    );

    try {
      final newToken = await _refreshTokenWithRetry();

      if (newToken == null) {
        await _handleAuthFailure();
        return handler.next(err);
      }

      // Retry the original request with new token
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      MyLogger.error('[AuthInterceptor] Token refresh retry failed: $e');
      await _handleAuthFailure();
      return handler.next(err);
    }
  }

  /// Refreshes the access token with retry logic for network errors
  Future<String?> _refreshTokenWithRetry() async {
    // If already refreshing, wait for the existing refresh to complete
    if (_isRefreshing && _refreshCompleter != null) {
      MyLogger.info('[AuthInterceptor] Waiting for existing refresh...');
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      String? result;
      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        try {
          MyLogger.info(
            '[AuthInterceptor] Refreshing token (attempt $attempt/$_maxRetries)...',
          );

          final response = await dio
              .post(
                MyConstants.refreshToken,
                options: Options(
                  headers: {'Authorization': null},
                  // Ensure cookies are sent for refresh token
                  extra: {'withCredentials': true},
                  sendTimeout: _refreshTimeout,
                  receiveTimeout: _refreshTimeout,
                ),
              )
              .timeout(_refreshTimeout);

          final newAccessToken = response.data['access_token'] as String?;

          if (newAccessToken != null) {
            await secureStorage.saveAccessToken(newAccessToken);
            MyLogger.info('[AuthInterceptor] Token refreshed successfully');
            result = newAccessToken;
            break; // Success, exit retry loop
          } else {
            MyLogger.warning(
              '[AuthInterceptor] No access token in refresh response',
            );
            // This is likely an auth failure, not a network issue
            result = null;
            break;
          }
        } on DioException catch (e) {
          if (_isNetworkError(e)) {
            MyLogger.warning(
              '[AuthInterceptor] Network error on attempt $attempt/$_maxRetries: ${e.message}',
            );

            if (attempt < _maxRetries) {
              final delay =
                  _initialRetryDelay * (attempt * 2); // Exponential backoff
              MyLogger.info(
                '[AuthInterceptor] Retrying in ${delay.inSeconds} seconds...',
              );
              await Future.delayed(delay);
              continue;
            } else {
              MyLogger.error(
                '[AuthInterceptor] All retry attempts failed due to network errors',
              );
              result = null;
              break;
            }
          } else {
            // Non-network error (likely auth failure), don't retry
            MyLogger.error(
              '[AuthInterceptor] Auth error during token refresh: ${e.message}',
            );
            result = null;
            break;
          }
        } catch (e) {
          MyLogger.error(
            '[AuthInterceptor] Unexpected error during token refresh: $e',
          );
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

  /// Checks if a DioException is a network-related error that might be temporary
  bool _isNetworkError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // Consider 5xx server errors as temporary network issues
        final statusCode = error.response?.statusCode;
        return statusCode != null && statusCode >= 500;
      default:
        return false;
    }
  }

  /// Handles authentication failure by clearing tokens and notifying listeners
  Future<void> _handleAuthFailure() async {
    MyLogger.warning(
      '[AuthInterceptor] Authentication failed after all retries, clearing tokens...',
    );
    await secureStorage.clearTokens();
    await secureStorage.clearEmail();
    onAuthFailure?.call();
  }
}
