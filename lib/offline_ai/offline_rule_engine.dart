import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineRuleEngine {
  /// Evaluates whether an immediate intervention is required based on local sensor states
  bool requiresImmediateIntervention({
    required double currentFatigue,
    required double blinkRatePerMinute,
    required double sessionDurationMinutes,
  }) {
    // Immediate stop if session > 120 mins with no breaks
    if (sessionDurationMinutes > 120) {
      return true;
    }

    // Stop if fatigue is critical
    if (currentFatigue > 85) {
      return true;
    }

    // Stop if blink rate drops dangerously low for an extended period
    if (blinkRatePerMinute < 5 && sessionDurationMinutes > 30) {
      return true;
    }

    return false;
  }
}

final offlineRuleEngineProvider = Provider((ref) => OfflineRuleEngine());
