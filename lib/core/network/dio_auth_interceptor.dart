import 'package:dio/dio.dart';
import 'package:mirath/core/services/secure_storage_service.dart';
import 'package:mirath/core/utils/my_constants.dart';


// ------------ Interceptor to handle auth token attachment and refresh ------------

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService secureStorage;

  bool _isRefreshing = false;
  final List<void Function(String)> _retryQueue = [];

  AuthInterceptor({
    required this.dio,
    required this.secureStorage,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await secureStorage.getRefreshToken();
    if (refreshToken == null) {
      await secureStorage.clearTokens();
      return handler.next(err);
    }

    if (_isRefreshing) {
      _retryQueue.add((newToken) {
        err.requestOptions.headers['Authorization'] =
            'Bearer $newToken';
      });
      return;
    }

    _isRefreshing = true;

    try {
      final response = await dio.post(
        MyConstants.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await secureStorage.saveAccessToken(newAccessToken);
      await secureStorage.saveRefreshToken(newRefreshToken);

      for (final retry in _retryQueue) {
        retry(newAccessToken);
      }
      _retryQueue.clear();

      err.requestOptions.headers['Authorization'] =
          'Bearer $newAccessToken';

      _isRefreshing = false;

      final cloned = await dio.fetch(err.requestOptions);
      return handler.resolve(cloned);
    } catch (_) {
      _isRefreshing = false;
      _retryQueue.clear();
      await secureStorage.clearTokens();
      return handler.next(err);
    }
  }
}
