class AddictionTrackerService {
  /// Tracks usage frequency and duration for specific app categories.
  Map<String, double> calculateAddictionMetrics(
    Map<String, Duration> usageData,
  ) {
    final Map<String, double> scores = {};

    usageData.forEach((category, duration) {
      // Calculate score based on daily limit (e.g. 2 hours for social)
      double limit = 120.0; // minutes
      double score = (duration.inMinutes / limit).clamp(0.0, 1.0);
      scores[category] = score;
    });

    return scores;
  }

  /// Determines if a "Digital Detox" is recommended.
  bool shouldSuggestDetox(Map<String, double> addictionScores) {
    return addictionScores.values.any((score) => score > 0.9);
  }
}
