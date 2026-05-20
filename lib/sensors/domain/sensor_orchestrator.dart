import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:battery_plus/battery_plus.dart';

/// A comprehensive device context representing the current physical environment 
/// and hardware state of the device.
class DeviceContext {
  final UserMotionState motionState;
  final int ambientLightLux;
  final bool isProximityNear;
  final int batteryLevel;
  final BatteryState batteryState;

  DeviceContext({
    required this.motionState,
    required this.ambientLightLux,
    required this.isProximityNear,
    required this.batteryLevel,
    required this.batteryState,
  });

  @override
  String toString() {
    return 'DeviceContext(motion: $motionState, light: $ambientLightLux, near: $isProximityNear, battery: $batteryLevel%)';
  }
}

enum UserMotionState { stationary, moving, shaking }

/// Orchestrates multiple hardware sensors to provide a unified `DeviceContext` stream.
class SensorOrchestrator extends ChangeNotifier {
  static final SensorOrchestrator _instance = SensorOrchestrator._internal();
  factory SensorOrchestrator() => _instance;
  SensorOrchestrator._internal();

  // Streams and Subscriptions
  StreamSubscription<UserAccelerometerEvent>? _accelSub;
  StreamSubscription<int>? _lightSub;
  StreamSubscription<int>? _proximitySub;
  StreamSubscription<BatteryState>? _batteryStateSub;

  final Light _light = Light();
  final Battery _battery = Battery();

  // Current State
  UserMotionState _currentMotion = UserMotionState.stationary;
  int _currentLightLux = 500;
  bool _isNear = false;
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.full;

  final StreamController<DeviceContext> _contextStreamController = StreamController<DeviceContext>.broadcast();

  Stream<DeviceContext> get contextStream => _contextStreamController.stream;

  DeviceContext get currentContext => DeviceContext(
        motionState: _currentMotion,
        ambientLightLux: _currentLightLux,
        isProximityNear: _isNear,
        batteryLevel: _batteryLevel,
        batteryState: _batteryState,
      );

  Future<void> initialize() async {
    _batteryLevel = await _battery.batteryLevel;
    
    // Listen to Battery
    _batteryStateSub = _battery.onBatteryStateChanged.listen((state) {
      _batteryState = state;
      _emitContext();
    });

    // Listen to Motion (UserAccelerometer ignores gravity)
    _accelSub = userAccelerometerEventStream().listen((event) {
      final double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
      UserMotionState newState = UserMotionState.stationary;
      
      if (magnitude > 15.0) {
        newState = UserMotionState.shaking;
      } else if (magnitude > 2.5) {
        newState = UserMotionState.moving;
      }

      if (newState != _currentMotion) {
        _currentMotion = newState;
        _emitContext();
      }
    });

    // Listen to Light Sensor
    try {
      _lightSub = _light.lightSensorStream.listen((lux) {
        // Debounce small changes if necessary, for now we emit
        if ((_currentLightLux - lux).abs() > 20) {
          _currentLightLux = lux;
          _emitContext();
        }
      });
    } catch (e) {
      debugPrint("Light sensor not available: $e");
    }

    // Listen to Proximity Sensor
    try {
      _proximitySub = ProximitySensor.events.listen((int event) {
        final near = event > 0;
        if (near != _isNear) {
          _isNear = near;
          _emitContext();
        }
      });
    } catch (e) {
      debugPrint("Proximity sensor not available: $e");
    }
    
    // Initial Emission
    _emitContext();
  }

  void _emitContext() {
    _contextStreamController.add(currentContext);
    notifyListeners();
  }

  void disposeOrchestrator() {
    _accelSub?.cancel();
    _lightSub?.cancel();
    _proximitySub?.cancel();
    _batteryStateSub?.cancel();
    _contextStreamController.close();
  }
}
