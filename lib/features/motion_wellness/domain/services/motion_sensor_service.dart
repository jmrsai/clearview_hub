import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/foundation.dart';

class MotionSensorService {
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;

  // Shaky movement detection thresholds
  static const double _shakyThreshold = 2.0;

  final _shakyController = StreamController<bool>.broadcast();
  Stream<bool> get shakyMovementStream => _shakyController.stream;

  bool _isTravelModeAutoSuggested = false;

  void startMonitoring() {
    _accelerometerSubscription = userAccelerometerEventStream().listen((
      UserAccelerometerEvent event,
    ) {
      final double magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > _shakyThreshold) {
        _shakyController.add(true);
        if (!_isTravelModeAutoSuggested) {
          _isTravelModeAutoSuggested = true;
          debugPrint('Shaky movement detected: Potential travel condition.');
        }
      } else {
        _shakyController.add(false);
      }
    });
  }

  void stopMonitoring() {
    _accelerometerSubscription?.cancel();
  }

  void resetAutoSuggest() {
    _isTravelModeAutoSuggested = false;
  }
}
