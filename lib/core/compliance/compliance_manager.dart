import 'package:shared_preferences/shared_preferences.dart';

class ComplianceManager {
  static final ComplianceManager _instance = ComplianceManager._internal();
  factory ComplianceManager() => _instance;
  ComplianceManager._internal();

  static const String _consentKey = 'user_medical_consent_granted';
  static const String _consentTimestampKey = 'user_medical_consent_timestamp';

  Future<bool> hasGrantedConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }

  Future<void> grantConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
    await prefs.setString(_consentTimestampKey, DateTime.now().toIso8601String());
  }

  Future<void> revokeConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, false);
    await prefs.remove(_consentTimestampKey);
  }
}
