import 'package:health/health.dart';
import 'package:flutter/foundation.dart';

class HealthService extends ChangeNotifier {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  bool _isAuthorized = false;

  /// Supported data types for comprehensive clinical analysis
  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
  ];

  bool get isAuthorized => _isAuthorized;

  /// Initialize and authorize connection to Health Ecosystems 
  /// (Apple Health, Google Fit, Samsung Health via Health Connect)
  Future<void> authorize() async {
    try {
      // Request authorization for the data types
      _isAuthorized = await _health.requestAuthorization(_types);
      notifyListeners();
    } catch (e) {
      debugPrint('Health Authorization Error: $e');
      _isAuthorized = false;
    }
  }

  /// Fetch medical data from all integrated providers
  Future<List<HealthDataPoint>> fetchHealthData() async {
    if (!_isAuthorized) await authorize();

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    try {
      return await _health.getHealthDataFromTypes(
        startTime: oneWeekAgo,
        endTime: now,
        types: _types,
      );
    } catch (e) {
      debugPrint('Error fetching health data: $e');
      return [];
    }
  }

  /// Revoke permissions (for privacy compliance)
  Future<void> revokePermissions() async {
    // Note: Most native APIs don't allow programmatic revocation of individual permissions
    // but we can clear our local state.
    _isAuthorized = false;
    notifyListeners();
  }
}
