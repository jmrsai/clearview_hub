class FatigueAiService {
  /// Heuristic logic to calculate real-time fatigue.
  double calculateCurrentFatigue({
    required double blinkRate,
    required double screenTimeHours,
    required bool isLowLight,
  }) {
    double fatigue = 0.0;

    // Normal blink rate is ~15-20. Anything less increases fatigue.
    if (blinkRate < 10) {
      fatigue += 0.4;
    } else if (blinkRate < 15)
      fatigue += 0.2;

    // Long screen time increases fatigue.
    fatigue += (screenTimeHours / 10).clamp(0.0, 0.4);

    // Low light usage is highly straining.
    if (isLowLight) fatigue += 0.2;

    return fatigue.clamp(0.0, 1.0);
  }
}
