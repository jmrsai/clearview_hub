import '../core/ai_model_base.dart';

class RecommendationEngineService {
  /// Aggregates various metrics to suggest the next best action for the user.
  String suggestNextStep({
    required double riskScore,
    required double fatigueLevel,
    required bool isTravelMode,
  }) {
    if (riskScore > 80) {
      return 'Schedule an immediate tele-consultation with a specialist.';
    }
    if (fatigueLevel > 0.7) {
      return "Digital Eye Strain detected. Start the '20-20-20' exercise now.";
    }
    if (isTravelMode) {
      return "Enable 'Travel Wellness' mode to reduce vehicle-induced strain.";
    }

    return "You're doing great! Keep up your current ocular hygiene habits.";
  }
}
