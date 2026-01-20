class MyConstants {
  MyConstants._();

  // app name
  static const String appName = "Mirath";

  
  static const String googleServerClientId =
      "551081167484-bruuovdj7oal5gsej29vbja5803a3520.apps.googleusercontent.com";

  // storage keys
  static const String onboardingKey = 'has_seen_onboarding';
  static const String profileSetupKey = 'has_setup_profile';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String emailKey = 'user_email';
  // base url
  // Use 10.0.2.2 for Android emulator (maps to host machine's localhost)
  // Use your computer's IP (e.g., 192.168.x.x) for real devices
  // Use 127.0.0.1 for iOS simulator or web
  static const String baseUrl = "http://192.168.1.5:3000/";

  // Endpoints
  // ***Auth endpoints***
  // post
  static const String signUp = "api/v1/auth/signup";
  // post
  static const String verifyEmail = "api/v1/auth/verify-email";
  // post
  static const String resendVerification = "api/v1/auth/resend-verification";
  // post
  static const String google = "api/v1/auth/google";
  // post
  static const String login = "api/v1/auth/login";
  // post
  static const String logout = "api/v1/auth/logout";
  // post
  static const String forgetPassword = "api/v1/auth/forget-password";
  // post
  static const String verifyResetPasswordOTP = "api/v1/auth/verify-reset-code";
  // post
  static const String resetPassword = "api/v1/auth/reset-password";
  // post
  static const String refreshToken = "api/v1/auth/refresh";
  // post
  static const String isVerified = "api/v1/auth/is-verified";
  // get
  static const String checkSetup = "api/v1/auth/check-setup";
}
