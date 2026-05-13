import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:spen_remote/spen_remote.dart';

class SamsungIntegrationService extends ChangeNotifier {
  static final SamsungIntegrationService _instance = SamsungIntegrationService._internal();
  factory SamsungIntegrationService() => _instance;
  SamsungIntegrationService._internal();

  final Health _health = Health();
  bool _isSPenConnected = false;
  String _lastSPenAction = "None";

  bool get isSPenConnected => _isSPenConnected;
  String get lastSPenAction => _lastSPenAction;

  /// Initialize Samsung-specific features
  Future<void> initialize() async {
    await _initSPen();
    await _initSamsungHealth();
  }

  /// Initialize S-Pen Remote connectivity
  Future<void> _initSPen() async {
    try {
      await SpenRemote.connect();
      SpenRemote.events.listen((event) {
        _lastSPenAction = event.type;
        debugPrint('S-Pen Event: $_lastSPenAction');
        notifyListeners();
      });
      _isSPenConnected = true;
      notifyListeners();
    } catch (e) {
      debugPrint('S-Pen Init Error: $e');
    }
  }

  /// Initialize Samsung Health (via Health Connect)
  Future<void> _initSamsungHealth() async {
    // Health Connect is the recommended bridge for Samsung Health
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_SESSION,
    ];
    
    try {
      bool requested = await _health.requestAuthorization(types);
      if (requested) {
        debugPrint('Samsung Health (Health Connect) Authorization Granted');
      }
    } catch (e) {
      debugPrint('Samsung Health Init Error: $e');
    }
  }

  /// Fetch recent health data specifically from Samsung Health source
  Future<List<HealthDataPoint>> fetchRecentData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return await _health.getHealthDataFromTypes(
      startTime: yesterday,
      endTime: now,
      types: [HealthDataType.STEPS, HealthDataType.HEART_RATE],
    );
  }
}
