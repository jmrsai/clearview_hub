class WellnessPredictionService {
  /// Predicts focus levels and potential burnout based on historical sensor and usage data.

  Map<String, dynamic> predictFutureWellness({
    required double currentStrain,
    required double currentAddiction,
    required double sleepHours,
    required List<double> focusHistory,
  }) {
    // 1. Fatigue Forecasting
    double fatigueTrend = _calculateTrend(focusHistory);
    double predictedFatigue = (currentStrain + (fatigueTrend * 24)).clamp(
      0,
      100,
    );

    // 2. Burnout Risk (0.0 - 1.0)
    double burnoutRisk =
        (currentAddiction * 0.4) +
        (predictedFatigue / 100 * 0.4) +
        (1.0 - (sleepHours / 8.0) * 0.2);

    return {
      'predicted_fatigue': predictedFatigue,
      'burnout_risk': burnoutRisk.clamp(0, 1.0),
      'focus_forecast': fatigueTrend > 0 ? 'Improving' : 'Declining',
      'suggested_detox_hours': burnoutRisk > 0.7
          ? 4
          : (burnoutRisk > 0.4 ? 1 : 0),
    };
  }

  double _calculateTrend(List<double> data) {
    if (data.length < 2) return 0.05;
    return (data.last - data.first) / data.length;
  }
}
