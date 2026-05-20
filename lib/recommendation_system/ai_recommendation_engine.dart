import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WellnessContentType { game, therapy, video, exercise, focusSession }

class WellnessRecommendation {
  final String title;
  final WellnessContentType type;
  final String reason;

  WellnessRecommendation({
    required this.title,
    required this.type,
    required this.reason,
  });
}

/// AI Recommendation Engine
class AIRecommendationEngine {
  List<WellnessRecommendation> generateRecommendations({
    required double eyeHealthScore,
    required double addictionScore,
    required String currentMood,
    required int userAge,
  }) {
    List<WellnessRecommendation> recommendations = [];

    // Rule-based logic (Pre-ML architecture)
    if (eyeHealthScore < 50) {
      recommendations.add(
        WellnessRecommendation(
          title: 'Palming Therapy Session',
          type: WellnessContentType.therapy,
          reason:
              'Your eye strain score is high. Palming helps relax the ciliary muscles.',
        ),
      );
      recommendations.add(
        WellnessRecommendation(
          title: 'Blink Master Game',
          type: WellnessContentType.game,
          reason: 'Improves your blink rate to reduce dry eyes.',
        ),
      );
    }

    if (addictionScore > 70) {
      recommendations.add(
        WellnessRecommendation(
          title: 'Guided 2-Hour Detox',
          type: WellnessContentType.focusSession,
          reason:
              'Your digital addiction score indicates a need for immediate disconnect.',
        ),
      );
    }

    if (currentMood == 'stressed') {
      recommendations.add(
        WellnessRecommendation(
          title: 'Calming Visualizations',
          type: WellnessContentType.video,
          reason: 'Selected to reduce stress and lower cortisol levels.',
        ),
      );
    }

    // Default fallback
    if (recommendations.isEmpty) {
      recommendations.add(
        WellnessRecommendation(
          title: 'Daily Eye Yoga',
          type: WellnessContentType.exercise,
          reason: 'Maintain your excellent eye health streak.',
        ),
      );
    }

    return recommendations;
  }
}

final aiRecommendationProvider = Provider((ref) => AIRecommendationEngine());
