import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Governs the computational complexity of Quantum Math operations.
/// Prevents the application from crashing low-end mobile devices 
/// while fully utilizing high-end Desktop/Web CPUs.
class DeviceQuantumGovernor {
  static final DeviceQuantumGovernor _instance = DeviceQuantumGovernor._internal();
  factory DeviceQuantumGovernor() => _instance;
  DeviceQuantumGovernor._internal();

  int get maxTensorThreads {
    if (kIsWeb) return 8; // Modern browsers can handle high threading
    if (Platform.isIOS || Platform.isAndroid) return 2; // Throttle mobile
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) return 16; // Extreme desktop mode
    return 2;
  }

  double get matrixPrecisionLevel {
    if (kIsWeb) return 0.95; // High precision (FP32 equivalent)
    if (Platform.isIOS || Platform.isAndroid) return 0.60; // INT8 equivalent (Fast, low battery usage)
    return 1.0; // Absolute maximum precision for Desktop
  }

  bool get canRunBackgroundBots {
    if (kIsWeb) return false; // Web workers are complex, keep to main thread mostly
    if (Platform.isIOS || Platform.isAndroid) return true; // Background isolates enabled
    return true; // Desktop
  }
}
