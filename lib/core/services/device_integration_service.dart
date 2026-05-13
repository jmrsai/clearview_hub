import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';

class DeviceIntegrationService extends ChangeNotifier {
  static final DeviceIntegrationService _instance = DeviceIntegrationService._internal();
  factory DeviceIntegrationService() => _instance;
  DeviceIntegrationService._internal();

  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  BluetoothDevice? _connectedDevice;

  List<ScanResult> get scanResults => _scanResults;
  bool get isScanning => _isScanning;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  /// Start scanning for medical IOT devices (Pulse Oximeters, BP Monitors)
  Future<void> startScan() async {
    if (_isScanning) return;
    
    _isScanning = true;
    _scanResults = [];
    notifyListeners();

    FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    _isScanning = false;
    notifyListeners();
  }

  /// Connect to a specific medical device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      // Named 'license' parameter is required for flutter_blue_plus 2.3.2
      await device.connect(autoConnect: false, license: License.free);
      _connectedDevice = device;
      notifyListeners();
      
      // Discover services (e.g. Heart Rate Service 0x180D)
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        debugPrint('Found Service: ${service.uuid}');
      }
      
      return true;
    } catch (e) {
      debugPrint('Connection Error: $e');
      return false;
    }
  }

  /// Disconnect current device
  Future<void> disconnect() async {
    await _connectedDevice?.disconnect();
    _connectedDevice = null;
    notifyListeners();
  }
}
