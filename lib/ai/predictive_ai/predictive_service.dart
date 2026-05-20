class PredictiveAiService {
  /// Predicts future eye fatigue based on current usage trends.
  /// Returns a forecast map of time vs predicted fatigue level.
  Map<DateTime, double> predictFatigueForecast(List<double> historicalFatigue) {
    final now = DateTime.now();
    final Map<DateTime, double> forecast = {};

    // Simple linear projection (placeholder for time-series ML)
    double averageGrowth = historicalFatigue.length > 1
        ? (historicalFatigue.last - historicalFatigue.first) /
              historicalFatigue.length
        : 0.05;

    double currentLevel = historicalFatigue.isNotEmpty
        ? historicalFatigue.last
        : 0.2;

    for (int i = 1; i <= 4; i++) {
      currentLevel = (currentLevel + averageGrowth).clamp(0.0, 1.0);
      forecast[now.add(Duration(hours: i))] = currentLevel;
    }

    return forecast;
  }
}
