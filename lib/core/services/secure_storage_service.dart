import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/my_constants.dart';

// ------------ Deals with secure storage of sensitive data ------------
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const _accessTokenKey = MyConstants.accessTokenKey;
  static const _refreshTokenKey = MyConstants.refreshTokenKey;
  static const _emailKey = MyConstants.emailKey;
  static const _setupStatusKey = MyConstants.setupStatusKey;

  // ========== Token Storage ==========
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
    await _storage.delete(key: _setupStatusKey); // Clear setup status on logout
  }

  // ========== Email Storage ==========
  Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<void> clearEmail() async {
    await _storage.delete(key: _emailKey);
  }

  // ========== Setup Status Storage ==========
  Future<void> saveSetupStatus(bool isSetup) async {
    await _storage.write(key: _setupStatusKey, value: isSetup.toString());
  }

  Future<bool?> getSetupStatus() async {
    final status = await _storage.read(key: _setupStatusKey);
    if (status == null) return null;
    return status.toLowerCase() == 'true';
  }

  Future<void> clearSetupStatus() async {
    await _storage.delete(key: _setupStatusKey);
  }
}
