class AppConstants {
  static const String appName = 'EyeVerse AI';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String isFirstTimeKey = 'isFirstTime';
  static const String userTokenKey = 'userToken';
  static const String themeModeKey = 'themeMode';

  // Feature Flags
  static const bool enableTelemedicine = true;
  static const bool enableAITriage = true;

  // Timeouts
  static const int connectionTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms
}
