/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/foundation.dart';

/// Service responsible for Digital Phenotyping.
/// It uses carp_mobile_sensing to passively collect data (screen state, ambient light, mobility)
/// to detect digital eye strain or degrading vision behavior.
class DigitalPhenotypingService extends ChangeNotifier {
  static final DigitalPhenotypingService _instance = DigitalPhenotypingService._internal();
  factory DigitalPhenotypingService() => _instance;
  DigitalPhenotypingService._internal();

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Future<void> initializeAndStart() async {
    if (_isRunning) return;
    try {
      // Background passive sensing initialized (Mock)
      _isRunning = true;
      _startSimulatedSensing();
      notifyListeners();
      debugPrint("Digital Phenotyping Service: Background monitoring active.");
    } catch (e) {
      debugPrint("Error initializing phenotyping: $e");
    }
  }

  void _startSimulatedSensing() {
    // Simulate periodic eye strain detection based on screen time
    Future.delayed(const Duration(seconds: 5), () {
      if (_isRunning) {
        debugPrint("Phenotyping Alert: High screen time detected.");
      }
    });
  }

  void stop() {
    _isRunning = false;
    notifyListeners();
    debugPrint("Digital Phenotyping Service Stopped.");
  }
}
