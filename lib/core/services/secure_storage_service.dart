import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/my_constants.dart';


// ------------ Deals with secure storage of sensitive data ------------
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

    static const _accessTokenKey = MyConstants.accessTokenKey;
    static const _refreshTokenKey = MyConstants.refreshTokenKey;

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
