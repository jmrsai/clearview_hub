import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddictionInputs {
  final double dailyScreenUsageHours;
  final int appSwitchingFrequencyPerHour;
  final double nightUsageHours;
  final double avgSessionDurationMinutes;
  final double socialMediaUsageHours;

  AddictionInputs({
    required this.dailyScreenUsageHours,
    required this.appSwitchingFrequencyPerHour,
    required this.nightUsageHours,
    required this.avgSessionDurationMinutes,
    required this.socialMediaUsageHours,
  });
}

class AddictionResult {
  final double score; // 0 to 100
  final String detoxRecommendation;
  final String focusRecommendation;

  AddictionResult({
    required this.score,
    required this.detoxRecommendation,
    required this.focusRecommendation,
  });
}

/// Digital Addiction Calculation Algorithm
class DigitalAddictionAlgorithm {
  AddictionResult calculateAddiction(AddictionInputs inputs) {
    double score = 0.0;

    // Daily total usage (Over 4 hours starts penalizing)
    if (inputs.dailyScreenUsageHours > 4) {
      score += (inputs.dailyScreenUsageHours - 4) * 10;
    }

    // Context switching / Dopamine loop seeking
    if (inputs.appSwitchingFrequencyPerHour > 20) {
      score += (inputs.appSwitchingFrequencyPerHour - 20) * 0.5;
    }

    // Late night usage disrupts sleep and is a strong indicator
    score += inputs.nightUsageHours * 15;

    // Long uninterrupted sessions
    if (inputs.avgSessionDurationMinutes > 60) {
      score += (inputs.avgSessionDurationMinutes - 60) * 0.5;
    }

    // High social media ratio
    score += inputs.socialMediaUsageHours * 5;

    score = score.clamp(0, 100);

    String detoxRecommendation = 'Maintain current healthy habits.';
    String focusRecommendation = 'No specific intervention needed.';

    if (score >= 80) {
      detoxRecommendation =
          'Strict 24-hour Digital Detox strongly recommended.';
      focusRecommendation =
          'Enable strict Focus Mode blocking all social media.';
    } else if (score >= 60) {
      detoxRecommendation =
          'Consider an evening detox (no screens after 8 PM).';
      focusRecommendation = 'Use Pomodoro technique for daily tasks.';
    } else if (score >= 40) {
      detoxRecommendation = 'Monitor usage. Try to reduce social media by 20%.';
      focusRecommendation = 'Set app limits for high-usage applications.';
    }

    return AddictionResult(
      score: score,
      detoxRecommendation: detoxRecommendation,
      focusRecommendation: focusRecommendation,
    );
  }
}

final digitalAddictionProvider = Provider((ref) => DigitalAddictionAlgorithm());
