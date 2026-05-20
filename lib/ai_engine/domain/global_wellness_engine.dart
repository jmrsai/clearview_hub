import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clearview_hub/sensors/domain/sensor_orchestrator.dart';

// Represents the global state of the user's digital wellness
class WellnessState {
  final double globalScore; // 0 - 100
  final double eyeStrainScore;
  final double mentalFatigueIndex;
  final double postureHealth;
  final String activeMode; // Study, Gaming, Relax, Travel, etc.
  final String recommendation;

  WellnessState({
    this.globalScore = 100.0,
    this.eyeStrainScore = 0.0,
    this.mentalFatigueIndex = 0.0,
    this.postureHealth = 100.0,
    this.activeMode = 'Normal',
    this.recommendation = 'Everything looks good!',
  });

  WellnessState copyWith({
    double? globalScore,
    double? eyeStrainScore,
    double? mentalFatigueIndex,
    double? postureHealth,
    String? activeMode,
    String? recommendation,
  }) {
    return WellnessState(
      globalScore: globalScore ?? this.globalScore,
      eyeStrainScore: eyeStrainScore ?? this.eyeStrainScore,
      mentalFatigueIndex: mentalFatigueIndex ?? this.mentalFatigueIndex,
      postureHealth: postureHealth ?? this.postureHealth,
      activeMode: activeMode ?? this.activeMode,
      recommendation: recommendation ?? this.recommendation,
    );
  }
}

// The Master AI Risk Engine
class GlobalWellnessEngine extends StateNotifier<WellnessState> {
  final Ref ref;
  Timer? _analysisTimer;

  GlobalWellnessEngine(this.ref) : super(WellnessState()) {
    _startContinuousAnalysis();
  }

  void _startContinuousAnalysis() {
    // Run an analysis loop every 5 seconds to update the global wellness score
    _analysisTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _analyzeContext();
    });
  }

  void _analyzeContext() {
    // Collect data from actual sensor orchestrator
    final sensorState = SensorOrchestrator().currentContext;
    
    double newEyeStrain = state.eyeStrainScore;
    double newMentalFatigue = state.mentalFatigueIndex;
    double newPosture = state.postureHealth;
    String newMode = state.activeMode;
    String recommendation = state.recommendation;

    // Simulate fatigue increasing over time (simplified)
    newEyeStrain += 0.5; 
    newMentalFatigue += 0.3;

    // Incorporate Sensor Context
    if (sensorState.ambientLightLux < 10) {
      // Dark room usage = higher eye strain
      newEyeStrain += 2.0;
      newMode = 'Night Mode';
      recommendation = 'Low light detected. Consider turning on a lamp or Eye Comfort Shield.';
    }

    if (sensorState.motionState == UserMotionState.moving || sensorState.motionState == UserMotionState.shaking) {
      newMode = 'Travel Mode';
      newEyeStrain += 1.5; // Reading while moving increases strain
      recommendation = 'Movement detected. Try to avoid reading to prevent motion sickness and eye strain.';
    }

    if (sensorState.isProximityNear) {
      newEyeStrain += 5.0; // Device too close
      recommendation = 'Device is too close to your eyes! Move it back to at least 30cm.';
    }

    // Clamp values
    newEyeStrain = newEyeStrain.clamp(0.0, 100.0);
    newMentalFatigue = newMentalFatigue.clamp(0.0, 100.0);
    newPosture = newPosture.clamp(0.0, 100.0);

    // Calculate Global Score (0-100, where 100 is perfect health)
    // Formula: Start at 100, subtract penalties
    double penalty = (newEyeStrain * 0.4) + (newMentalFatigue * 0.4) + ((100 - newPosture) * 0.2);
    double globalScore = (100.0 - penalty).clamp(0.0, 100.0);

    // Extreme fatigue check
    if (globalScore < 40) {
      recommendation = 'CRITICAL: High fatigue detected. Please take a 20-minute break immediately.';
    }

    state = state.copyWith(
      globalScore: globalScore,
      eyeStrainScore: newEyeStrain,
      mentalFatigueIndex: newMentalFatigue,
      postureHealth: newPosture,
      activeMode: newMode,
      recommendation: recommendation,
    );
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    super.dispose();
  }
}

// Provider for the engine
final globalWellnessEngineProvider = StateNotifierProvider<GlobalWellnessEngine, WellnessState>((ref) {
  return GlobalWellnessEngine(ref);
});
