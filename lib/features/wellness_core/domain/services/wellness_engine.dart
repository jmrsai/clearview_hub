class WellnessMetrics {
  final double eyeStrainScore; // 0-100
  final double screenAddictionScore; // 0-100
  final double postureScore; // 0-100
  final double sleepQualityScore; // 0-100
  final double mentalFatigueScore; // 0-100
  final double hydrationScore; // 0-100

  WellnessMetrics({
    required this.eyeStrainScore,
    required this.screenAddictionScore,
    required this.postureScore,
    required this.sleepQualityScore,
    required this.mentalFatigueScore,
    required this.hydrationScore,
  });

  /// Calculate the unified Digital Wellness Score
  double calculateGlobalScore() {
    // Weighted average for the global score
    return (eyeStrainScore * 0.25) +
        (screenAddictionScore * 0.20) +
        (postureScore * 0.15) +
        (sleepQualityScore * 0.20) +
        (mentalFatigueScore * 0.10) +
        (hydrationScore * 0.10);
  }

  String getStatus() {
    final score = calculateGlobalScore();
    if (score >= 85) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'At Risk';
    return 'Critical';
  }
}

class WellnessEngine {
  /// Analyzes current metrics and returns personalized action recommendations
  List<String> getActionPlan(WellnessMetrics metrics) {
    final List<String> plan = [];

    if (metrics.eyeStrainScore < 60) {
      plan.add('Take a 20-20-20 eye break immediately.');
    }
    if (metrics.postureScore < 50) {
      plan.add('Perform 3 neck stretches and adjust your screen height.');
    }
    if (metrics.screenAddictionScore < 40) {
      plan.add('Enable Digital Detox mode for the next 1 hour.');
    }
    if (metrics.sleepQualityScore < 50) {
      plan.add('Avoid blue light exposure for 2 hours before bedtime.');
    }
    if (metrics.hydrationScore < 60) {
      plan.add('Drink a glass of water to maintain eye and brain health.');
    }

    if (plan.isEmpty) {
      plan.add("Maintain your excellent habits! You're doing great.");
    }

    return plan;
  }
}
