class ExplainableAiService {
  /// Generates a human-readable explanation of why an AI prediction was made.
  String generateExplanation({
    required String modelName,
    required dynamic predictionResult,
    required Map<String, double> featureImportance,
  }) {
    // Sort features by importance
    final sortedFeatures = featureImportance.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topFeature = sortedFeatures.first;

    return 'This $modelName result ($predictionResult) was primarily influenced by your ${topFeature.key}, which contributed ${(topFeature.value * 100).toStringAsFixed(1)}% to the final outcome.';
  }

  /// Visualizes uncertainty for medical accountability.
  String getUncertaintyStatement(double confidence) {
    if (confidence > 0.95) {
      return 'Very High Confidence - Result is highly reliable.';
    }
    if (confidence > 0.80) {
      return 'High Confidence - Standard clinical reliability.';
    }
    return 'Moderate Confidence - Doctor validation strongly recommended.';
  }
}
