import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../sensors/domain/sensor_orchestrator.dart';
import '../../age_profiles/domain/age_profile_manager.dart';

enum WellnessRiskLevel { low, medium, high, critical }
enum WellnessAction { takeBreak, eyeTherapy, postureCorrection, breathingExercise, digitalDetox, playFocusGame }

class WellnessRecommendation {
  final WellnessRiskLevel riskLevel;
  final WellnessAction suggestedAction;
  final String message;
  final DateTime timestamp;

  WellnessRecommendation({
    required this.riskLevel,
    required this.suggestedAction,
    required this.message,
    required this.timestamp,
  });
}

class WellnessDecisionEngine extends ChangeNotifier {
  static final WellnessDecisionEngine _instance = WellnessDecisionEngine._internal();
  factory WellnessDecisionEngine() => _instance;
  WellnessDecisionEngine._internal();

  StreamSubscription<DeviceContext>? _contextSub;
  double _currentWellnessScore = 100.0; // 0-100 scale
  WellnessRecommendation? _latestRecommendation;

  double get wellnessScore => _currentWellnessScore;
  WellnessRecommendation? get latestRecommendation => _latestRecommendation;

  final StreamController<WellnessRecommendation> _recommendationStreamController = StreamController.broadcast();
  Stream<WellnessRecommendation> get recommendationStream => _recommendationStreamController.stream;

  void initialize() {
    _contextSub = SensorOrchestrator().contextStream.listen((context) {
      _evaluateWellness(context);
    });
  }

  void _evaluateWellness(DeviceContext context) {
    double deduction = 0;
    
    // Low Light Penalty
    if (context.ambientLightLux < 10) {
      deduction += 5;
    } else if (context.ambientLightLux > 10000) {
      deduction += 5; // Glare
    }

    // Proximity Penalty
    if (context.isProximityNear) {
      deduction += 10;
    }

    // Motion Penalty (Reading while walking)
    if (context.motionState == UserMotionState.moving) {
      deduction += 8;
    } else if (context.motionState == UserMotionState.shaking) {
      deduction += 15;
    }

    // Battery / Long usage heuristic
    if (context.batteryLevel < 20 && context.batteryState != BatteryState.charging) {
       // Just an abstract penalty - implies long session usually
       deduction += 2; 
    }

    _currentWellnessScore = (100.0 - deduction).clamp(0.0, 100.0);

    // Apply Age Profile Modifiers
    final ageConfig = AgeProfileManager().currentConfig;
    if (ageConfig.group == AgeGroup.kids && _currentWellnessScore < 80) {
       // Kids get critical warnings much faster
       _currentWellnessScore -= 10;
    }

    _currentWellnessScore = _currentWellnessScore.clamp(0.0, 100.0);

    _generateRecommendation(context);
    notifyListeners();
  }

  void _generateRecommendation(DeviceContext context) {
    WellnessRiskLevel risk = WellnessRiskLevel.low;
    if (_currentWellnessScore < 30) {
      risk = WellnessRiskLevel.critical;
    } else if (_currentWellnessScore < 60) {
      risk = WellnessRiskLevel.high;
    } else if (_currentWellnessScore < 85) {
      risk = WellnessRiskLevel.medium;
    }

    if (risk == WellnessRiskLevel.low) {
      _latestRecommendation = null; // Clear out warnings
      return;
    }

    // Decide Action based on dominant sensor factor
    WellnessAction action = WellnessAction.takeBreak;
    String message = "Take a break to rest your eyes.";

    if (context.isProximityNear) {
      action = WellnessAction.postureCorrection;
      message = "Screen is too close to your face! Move it away.";
    } else if (context.ambientLightLux < 10) {
      action = WellnessAction.eyeTherapy;
      message = "Using phone in the dark strains eyes. Try Eye Therapy.";
    } else if (context.motionState != UserMotionState.stationary) {
      action = WellnessAction.takeBreak;
      message = "Reading while moving causes motion sickness and eye strain.";
    } else if (risk == WellnessRiskLevel.critical) {
      action = WellnessAction.digitalDetox;
      message = "Critical strain detected. Lock screen and detox.";
    }

    final newRec = WellnessRecommendation(
      riskLevel: risk,
      suggestedAction: action,
      message: message,
      timestamp: DateTime.now(),
    );

    // Only emit if it's a new or escalated recommendation
    if (_latestRecommendation == null || _latestRecommendation!.suggestedAction != action || _latestRecommendation!.riskLevel != risk) {
       _latestRecommendation = newRec;
       _recommendationStreamController.add(newRec);
    }
  }

  void disposeEngine() {
    _contextSub?.cancel();
    _recommendationStreamController.close();
  }
}
