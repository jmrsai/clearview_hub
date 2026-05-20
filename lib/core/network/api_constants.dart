class ApiConstants {
  static const String baseUrl =
      'https://api.eyeverse.ai/v1'; // Replace with actual backend

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';

  static const String patients = '/patients';
  static const String diagnosticReports = '/reports';
  static const String syncData = '/sync';

  static const String aiAnalyze = '/ai/analyze';
}
