import 'dart:convert';

import 'package:mirath/features/auth/data/models/auth_user_data.dart';

import 'local_storage_service.dart';

class UserCacheService {
  final LocalStorageService _localStorage;
  static const String _userDataKey = 'cached_user_data';

  UserCacheService(this._localStorage);

  /// Save user data to cache
  Future<void> saveUser(AuthUserData userData) async {
    final jsonString = jsonEncode(userData.toJson());
    await _localStorage.setData(_userDataKey, jsonString);
  }

  /// Get cached user data
  AuthUserData? getCachedUser() {
    final userDataString = _localStorage.getData(_userDataKey);
    if (userDataString != null) {
      try {
        final userData = jsonDecode(userDataString);
        return AuthUserData.fromJson(userData);
      } catch (e) {
        // Handle JSON parsing error
        return null;
      }
    }
    return null;
  }

  /// Clear cached user data
  Future<void> clearUser() async {
    await _localStorage.removeData(_userDataKey);
  }

  /// Check if user is cached
  bool get hasUser {
    return _localStorage.hasData(_userDataKey);
  }
}
