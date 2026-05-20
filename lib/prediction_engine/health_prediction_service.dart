import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthPrediction {
  final double burnoutRiskPercentage;
  final double sleepDisruptionRiskPercentage;
  final double eyeFatigueForecast; // Next 24h
  final String primaryWarning;

  HealthPrediction({
    required this.burnoutRiskPercentage,
    required this.sleepDisruptionRiskPercentage,
    required this.eyeFatigueForecast,
    required this.primaryWarning,
  });
}

/// Predictive Analytics System for Health
class HealthPredictionService {
  HealthPrediction runPredictiveAnalysis({
    required List<double> recentEyeStrainScores,
    required List<double> recentAddictionScores,
    required double averageSleepHours,
  }) {
    // Time-series trend analysis (simplified moving average)
    double avgStrain = recentEyeStrainScores.isNotEmpty
        ? recentEyeStrainScores.reduce((a, b) => a + b) /
              recentEyeStrainScores.length
        : 0;

    double avgAddiction = recentAddictionScores.isNotEmpty
        ? recentAddictionScores.reduce((a, b) => a + b) /
              recentAddictionScores.length
        : 0;

    double burnoutRisk = ((avgStrain + avgAddiction) / 2).clamp(0, 100);

    double sleepDisruption = 0;
    if (averageSleepHours < 6) {
      sleepDisruption = 80;
    } else if (averageSleepHours < 7.5) {
      sleepDisruption = 40;
    }

    // Forecast fatigue for next 24h based on momentum
    double fatigueForecast = (avgStrain * 1.2).clamp(0, 100);

    String warning = 'Healthy trends. Keep it up.';
    if (burnoutRisk > 75) {
      warning =
          'High risk of digital burnout in the next 3 days. Mandatory rest advised.';
    } else if (sleepDisruption > 70) {
      warning =
          'Severe sleep disruption predicted. Cease screen time 2 hours before bed.';
    }

    return HealthPrediction(
      burnoutRiskPercentage: burnoutRisk,
      sleepDisruptionRiskPercentage: sleepDisruption,
      eyeFatigueForecast: fatigueForecast,
      primaryWarning: warning,
    );
  }
}

final healthPredictionProvider = Provider((ref) => HealthPredictionService());
