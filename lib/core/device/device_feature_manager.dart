import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

enum DeviceManufacturer {
  samsung,
  apple,
  google,
  onePlus,
  xiaomi,
  oppo,
  vivo,
  honor,
  huawei,
  motorola,
  sony,
  realme,
  other,
}

class DeviceFeatureManager {
  static final DeviceFeatureManager _instance =
      DeviceFeatureManager._internal();
  factory DeviceFeatureManager() => _instance;
  DeviceFeatureManager._internal();

  DeviceManufacturer _manufacturer = DeviceManufacturer.other;
  DeviceManufacturer get manufacturer => _manufacturer;

  Future<void> initialize() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _manufacturer = _mapManufacturer(androidInfo.manufacturer);
    } else if (Platform.isIOS) {
      _manufacturer = DeviceManufacturer.apple;
    }
  }

  DeviceManufacturer _mapManufacturer(String manufacturer) {
    switch (manufacturer.toLowerCase()) {
      case 'samsung':
        return DeviceManufacturer.samsung;
      case 'google':
        return DeviceManufacturer.google;
      case 'oneplus':
        return DeviceManufacturer.onePlus;
      case 'xiaomi':
        return DeviceManufacturer.xiaomi;
      case 'oppo':
        return DeviceManufacturer.oppo;
      case 'vivo':
        return DeviceManufacturer.vivo;
      case 'honor':
        return DeviceManufacturer.honor;
      case 'huawei':
        return DeviceManufacturer.huawei;
      case 'motorola':
        return DeviceManufacturer.motorola;
      case 'sony':
        return DeviceManufacturer.sony;
      case 'realme':
        return DeviceManufacturer.realme;
      default:
        return DeviceManufacturer.other;
    }
  }

  /// Returns supported AI features based on the manufacturer
  List<String> getSupportedAiFeatures() {
    switch (_manufacturer) {
      case DeviceManufacturer.samsung:
        return [
          'Eye Tracking',
          'Galaxy AI Screen Distance',
          'AI Smart Reminders',
        ];
      case DeviceManufacturer.apple:
        return [
          'Apple Intelligence Vision',
          'Accessibility Voice Assist',
          'Screen-Time Analysis',
        ];
      case DeviceManufacturer.google:
        return [
          'Gemini AI Assistant',
          'Advanced Face Detection',
          'ML Kit Blink Detection',
        ];
      case DeviceManufacturer.xiaomi:
        return ['HyperAI Camera Analysis', 'Smart Reading Mode'];
      default:
        return [
          'Standard AI Eye Scan',
          'Basic Distance Warning',
          'Blink Monitoring',
        ];
    }
  }

  bool get supportsAdvancedEyeTracking =>
      _manufacturer == DeviceManufacturer.samsung ||
      _manufacturer == DeviceManufacturer.google ||
      _manufacturer == DeviceManufacturer.apple;
}
