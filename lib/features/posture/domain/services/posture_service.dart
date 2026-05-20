import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class PostureService {
  StreamSubscription<AccelerometerEvent>? _subscription;

  // Angle at which we consider the user is "slouching" (looking down too much)
  // When looking down, Z decreases and Y increases.
  static const double _slouchThresholdY = 7.5;

  final _slouchController = StreamController<bool>.broadcast();
  Stream<bool> get slouchStream => _slouchController.stream;

  void startMonitoring() {
    _subscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      // Basic heuristic for phone tilt
      bool isSlouching = event.y > _slouchThresholdY;
      _slouchController.add(isSlouching);
    });
  }

  void stopMonitoring() {
    _subscription?.cancel();
  }
}
