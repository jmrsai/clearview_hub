abstract class AiModelBase {
  /// Initialize the model (load weights, etc.)
  Future<void> initialize();

  /// Dispose of the model and free resources
  void dispose();

  /// Confidence threshold for safety cutoffs
  double get minConfidenceThreshold;
}

class AiPrediction<T> {
  final T result;
  final double confidence;
  final String explanation; // For Explainable AI
  final List<String> supportingEvidence;
  final bool requiresDoctorReview;

  AiPrediction({
    required this.result,
    required this.confidence,
    required this.explanation,
    this.supportingEvidence = const [],
    this.requiresDoctorReview = false,
  });

  bool get isReliable => confidence >= 0.85;
}
