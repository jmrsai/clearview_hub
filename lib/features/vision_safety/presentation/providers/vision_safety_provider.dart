import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/ai_vision_service.dart';

final aiVisionServiceProvider = Provider<AiVisionService>((ref) {
  final service = AiVisionService();
  ref.onDispose(() => service.dispose());
  return service;
});

final proximityWarningProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(aiVisionServiceProvider);
  return service.proximityWarningStream;
});

final blinkCountProvider = StreamProvider<int>((ref) {
  final service = ref.watch(aiVisionServiceProvider);
  return service.blinkStream;
});

/// Manages the 20-20-20 rule timer (Every 20 mins, look 20 feet away for 20 secs)
final twentyTwentyTwentyProvider = StateNotifierProvider<TimerNotifier, bool>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<bool> {
  Timer? _timer;
  
  // State represents whether the break overlay should be shown
  TimerNotifier() : super(false) {
    _startTimer();
  }

  void _startTimer() {
    // 20 minutes (using seconds for testing/demonstration)
    _timer = Timer.periodic(const Duration(minutes: 20), (timer) {
      state = true; // Show break overlay
      
      // Auto-hide after 20 seconds
      Future.delayed(const Duration(seconds: 20), () {
        if (mounted) state = false;
      });
    });
  }

  void dismissBreak() {
    state = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
