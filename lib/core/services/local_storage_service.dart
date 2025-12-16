import 'package:shared_preferences/shared_preferences.dart';

import '../utils/my_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// Factory method to initialize the service
  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // ========== Onboarding ==========

  /// Check if user has seen onboarding
  bool hasSeenOnboarding() {
    return _prefs.getBool(MyConstants.onboardingKey) ?? false;
  }

  /// Mark onboarding as seen
  Future<bool> setOnboardingSeen(bool value) async {
    return await _prefs.setBool(MyConstants.onboardingKey, value);
  }

  // ========== Profile Setup ==========

  /// Check if user has setup profile
  bool hasSetupProfile() {
    return _prefs.getBool(MyConstants.profileSetupKey) ?? false;
  }

  /// Mark profile as setup
  Future<bool>  setProfileSetup(bool value) async {
    return await _prefs.setBool(MyConstants.profileSetupKey, value);
  }

  // ========== Clear Data ==========

  /// Clear all stored data (useful for logout)
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  /// Clear only onboarding status
  Future<bool> clearOnboarding() async {
    return await _prefs.remove(MyConstants.onboardingKey);
  }

  /// Clear only profile setup status
  Future<bool> clearProfileSetup() async {
    return await _prefs.remove(MyConstants.profileSetupKey);
  }
}
