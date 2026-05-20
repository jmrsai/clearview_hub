import 'package:flutter/foundation.dart';

enum WellnessRisk { low, moderate, high, critical }

class LocalAiDecisionEngine {
  /// The "Core Brain" of the platform.
  /// Operates fully offline using rule-based heuristics and local model outputs.

  Map<String, dynamic> evaluateState({
    required Duration sessionDuration,
    required double ambientLight,
    required bool isMoving,
    required double blinkRate,
    required double proximityCm,
  }) {
    double strainScore = 0.0;
    List<String> recommendations = [];
    WellnessRisk risk = WellnessRisk.low;

    // Rule 1: Prolonged usage
    if (sessionDuration.inMinutes > 45) {
      strainScore += 30;
      recommendations.add(
        '45-minute usage reached. Take a 5-minute eye break.',
      );
    }

    // Rule 2: Low light risk
    if (ambientLight < 20) {
      strainScore += 20;
      recommendations.add(
        'Environment too dark. Low light increases digital strain.',
      );
    }

    // Rule 3: Unsafe distance
    if (proximityCm > 0 && proximityCm < 25) {
      strainScore += 25;
      recommendations.add(
        'Phone is too close to your face. Maintain 30cm+ distance.',
      );
    }

    // Rule 4: Blink frequency
    if (blinkRate < 10) {
      strainScore += 15;
      recommendations.add(
        'Blink rate is low. Try to blink more often to avoid dry eyes.',
      );
    }

    // Rule 5: Motion instability
    if (isMoving) {
      strainScore += 10;
      recommendations.add(
        "Reading in a moving vehicle. Enable 'Travel Mode' now.",
      );
    }

    // Determine Risk Level
    if (strainScore > 80) {
      risk = WellnessRisk.critical;
    } else if (strainScore > 50) {
      risk = WellnessRisk.high;
    } else if (strainScore > 30) {
      risk = WellnessRisk.moderate;
    }

    return {
      'score': strainScore.clamp(0, 100),
      'risk': risk,
      'recommendations': recommendations,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
