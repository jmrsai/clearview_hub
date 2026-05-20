import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Models the inputs required for eye strain calculation
class EyeStrainInputs {
  final double screenTimeMinutes;
  final double brightnessLevel; // 0.0 to 1.0
  final double ambientLightLux;
  final int blinkFrequencyPerMinute;
  final double usageDurationMinutes;
  final double deviceDistanceCm;
  final bool motionWhileReading;

  EyeStrainInputs({
    required this.screenTimeMinutes,
    required this.brightnessLevel,
    required this.ambientLightLux,
    required this.blinkFrequencyPerMinute,
    required this.usageDurationMinutes,
    required this.deviceDistanceCm,
    required this.motionWhileReading,
  });
}

class EyeStrainResult {
  final double score; // 0 to 100
  final String fatigueLevel; // Low, Moderate, High, Severe
  final String riskPrediction;

  EyeStrainResult({
    required this.score,
    required this.fatigueLevel,
    required this.riskPrediction,
  });
}

/// Eye Strain Detection Algorithm
class EyeStrainDetectionAlgorithm {
  EyeStrainResult calculateStrain(EyeStrainInputs inputs) {
    double score = 0.0;

    // Base score from continuous usage (heavy weight)
    score += (inputs.usageDurationMinutes / 60) * 20;

    // Distance penalty
    if (inputs.deviceDistanceCm < 30) {
      score += (30 - inputs.deviceDistanceCm) * 1.5;
    }

    // Blink rate penalty (Normal is ~15-20, anything below 10 is bad)
    if (inputs.blinkFrequencyPerMinute < 15) {
      score += (15 - inputs.blinkFrequencyPerMinute) * 2;
    }

    // Lighting mismatch (High brightness in low ambient light is bad)
    if (inputs.ambientLightLux < 50 && inputs.brightnessLevel > 0.5) {
      score += (inputs.brightnessLevel - 0.5) * 40;
    }

    // Motion penalty
    if (inputs.motionWhileReading) {
      score += 10;
    }

    score = score.clamp(0, 100);

    String fatigueLevel = 'Low';
    String riskPrediction = 'Safe usage patterns.';

    if (score >= 80) {
      fatigueLevel = 'Severe';
      riskPrediction =
          'High risk of CVS (Computer Vision Syndrome). Immediate break required.';
    } else if (score >= 60) {
      fatigueLevel = 'High';
      riskPrediction = 'Developing eye fatigue. 20-20-20 rule recommended.';
    } else if (score >= 30) {
      fatigueLevel = 'Moderate';
      riskPrediction =
          'Mild strain detected. Consider dimming screen or blinking more.';
    }

    return EyeStrainResult(
      score: score,
      fatigueLevel: fatigueLevel,
      riskPrediction: riskPrediction,
    );
  }
}

final eyeStrainAlgorithmProvider = Provider(
  (ref) => EyeStrainDetectionAlgorithm(),
);
