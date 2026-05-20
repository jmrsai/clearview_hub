import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:light/light.dart';
import 'package:geolocator/geolocator.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter/foundation.dart';

class HardwareSensorService {
  // Streams
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<int>? _proximitySubscription;
  StreamSubscription<int>? _lightSubscription;

  // Data
  double ambientLight = 0;
  bool isTooClose = false;
  double accelerometerX = 0, accelerometerY = 0, accelerometerZ = 0;

  Future<void> initialize() async {
    // Accelerometer for posture detection
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      accelerometerX = event.x;
      accelerometerY = event.y;
      accelerometerZ = event.z;
    });

    // Proximity for basic distance warning
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      isTooClose = (event > 0);
    });

    // Ambient light for brightness suggestions
    try {
      _lightSubscription = Light().lightSensorStream.listen((int lux) {
        ambientLight = lux.toDouble();
        _adjustBrightness(lux);
      });
    } catch (e) {
      debugPrint('Light sensor not available: $e');
    }
  }

  void _adjustBrightness(int lux) async {
    try {
      if (lux < 10) {
        // Very dark - suggest low brightness or night mode
      } else if (lux > 1000) {
        // Very bright - increase brightness
        await ScreenBrightness().setScreenBrightness(0.8);
      }
    } catch (e) {
      debugPrint('Error adjusting brightness: $e');
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
    _proximitySubscription?.cancel();
    _lightSubscription?.cancel();
  }
}
