import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clearview_hub/ai_engine/domain/global_wellness_engine.dart';
import 'package:clearview_hub/ai_engine/services/smart_notification_service.dart';
import 'package:clearview_hub/ai_engine/services/voice_command_service.dart';
import 'package:flutter/foundation.dart';

class SmartActionDispatcher {
  final Ref ref;
  WellnessState? _previousState;

  SmartActionDispatcher(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<WellnessState>(globalWellnessEngineProvider, (previous, next) {
      _previousState = previous;
      _evaluateActions(next);
    });
  }

  void _evaluateActions(WellnessState state) {
    // Check if mode changed
    if (_previousState?.activeMode != state.activeMode) {
      _triggerModeChange(state.activeMode);
    }

    // Check for extreme fatigue
    if (state.globalScore < 40 && (_previousState?.globalScore ?? 100) >= 40) {
      _triggerEmergencyBreak();
    }

    // Check for bad posture
    if (state.postureHealth < 50 && (_previousState?.postureHealth ?? 100) >= 50) {
      SmartNotificationService().showPostureWarning();
    }
  }

  void _triggerModeChange(String newMode) {
    debugPrint('Smart Action: Switching to $newMode');
    
    // Voice feedback
    VoiceCommandService().speak('Activating $newMode.');

    // Depending on the mode, we might dim the screen or change system settings
    // This is a placeholder for actual UI/brightness adjustments
  }

  void _triggerEmergencyBreak() {
    debugPrint('Smart Action: Emergency Break Required');
    SmartNotificationService().showEyeBreakAlert();
    VoiceCommandService().speak('Your digital fatigue is critical. Please lock your device and take a 20 minute break.');
  }
}

final smartActionDispatcherProvider = Provider<SmartActionDispatcher>((ref) {
  return SmartActionDispatcher(ref);
});
