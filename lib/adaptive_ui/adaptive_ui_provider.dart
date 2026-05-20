import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UIState {
  normal,
  calmMode, // High stress/addiction
  fatigueMode, // High eye strain (Low contrast, dark)
  nightMode, // Late hours
}

/// Adaptive UI Engine Provider
class AdaptiveUIState extends Notifier<UIState> {
  @override
  UIState build() {
    return UIState.normal;
  }

  void updateUIBasedOnSensors({
    required double currentFatigue,
    required double currentStress,
    required bool isNightTime,
  }) {
    if (isNightTime) {
      state = UIState.nightMode;
    } else if (currentFatigue > 75) {
      state = UIState.fatigueMode;
    } else if (currentStress > 70) {
      state = UIState.calmMode;
    } else {
      state = UIState.normal;
    }
  }

  ThemeData getAdaptiveTheme(ThemeData baseTheme) {
    switch (state) {
      case UIState.calmMode:
        return baseTheme.copyWith(
          scaffoldBackgroundColor: const Color(0xFF1E2A38), // Softer blue-grey
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: const Color(0xFF4A90E2),
          ),
        );
      case UIState.fatigueMode:
        // Ultra low contrast, deep black to rest eyes (AMOLED friendly)
        return baseTheme.copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: Colors.grey[700]!,
            onSurface: Colors.grey[400]!,
          ),
          textTheme: baseTheme.textTheme.apply(
            bodyColor: Colors.grey[400],
            displayColor: Colors.grey[400],
          ),
        );
      case UIState.nightMode:
        // Warmer colors, blue light reduction simulation
        return baseTheme.copyWith(
          scaffoldBackgroundColor: const Color(0xFF120E0A), // Warm dark
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: const Color(0xFFD35400), // Warm orange primary
          ),
        );
      case UIState.normal:
      default:
        return baseTheme;
    }
  }
}

final adaptiveUIProvider = NotifierProvider<AdaptiveUIState, UIState>(() {
  return AdaptiveUIState();
});
