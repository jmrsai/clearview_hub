import '../../models/eye_twin_metrics.dart';

class RiskScoringService {
  /// Calculates a holistic eye-health risk score (0-100).
  /// 0 = Low Risk, 100 = Critical Risk.
  double calculateRiskScore(EyeTwinMetrics metrics) {
    double score = 0.0;

    // Weighting factors
    score += (100 - metrics.visualAcuityScore) * 0.4;
    score += (metrics.screenTimeHours / 12) * 20; // Risk from long screen time
    score += metrics.fatigueLevel * 20; // Risk from acute fatigue
    score += (1 - metrics.therapyAdherence) * 20; // Risk from non-compliance

    return score.clamp(0.0, 100.0);
  }

  String getRiskLevel(double score) {
    if (score < 30) return 'Low Risk';
    if (score < 60) return 'Moderate Risk';
    if (score < 85) return 'High Risk';
    return 'Critical Risk';
  }
}
