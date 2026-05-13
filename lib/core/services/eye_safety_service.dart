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

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Implements WHO-recommended "Safe Viewing" protocols for digital health.
/// 
/// Features:
/// 1. 20-20-20 Rule: Every 20 mins, look at something 20ft away for 20s.
/// 2. Blink Rate Monitor: Encourages frequent blinking to prevent dry eye.
/// 3. Ergonomics Monitor: Simulated AI distance tracking.
class EyeSafetyService {
  EyeSafetyService._();
  static final EyeSafetyService instance = EyeSafetyService._();

  Timer? _safetyTimer;
  final _distanceController = StreamController<double>.broadcast();
  final _blinkController = StreamController<int>.broadcast();

  bool _isMonitoring = false;
  int _secondsUntilBreak = 1200; // 20 minutes

  // Getters
  Stream<double> get distanceStream => _distanceController.stream;
  Stream<int> get blinkStream => _blinkController.stream;
  int get secondsUntilBreak => _secondsUntilBreak;
  bool get isMonitoring => _isMonitoring;

  void startMonitoring() {
    if (_isMonitoring) return;
    _isMonitoring = true;
    _secondsUntilBreak = 1200;

    _safetyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsUntilBreak > 0) {
        _secondsUntilBreak--;
      } else {
        // Trigger break notification via UI callback or global state
        debugPrint('[EyeSafety] 20-20-20 Break Recommended!');
        _secondsUntilBreak = 1200; // Reset
      }
    });
    
    debugPrint('[EyeSafety] WHO Safety Monitoring Started');
  }

  void stopMonitoring() {
    _safetyTimer?.cancel();
    _isMonitoring = false;
    debugPrint('[EyeSafety] WHO Safety Monitoring Stopped');
  }

  /// Updates distance telemetry from Camera/AI module.
  /// Distance in cm. WHO recommends >30cm for mobile devices.
  void updateDistance(double distanceCm) {
    _distanceController.add(distanceCm);
    if (distanceCm < 30) {
      debugPrint('[EyeSafety] WARNING: Too close to screen (<30cm)');
    }
  }

  /// Updates blink count telemetry.
  /// Normal rate: 15-20 blinks/min.
  void recordBlink() {
    _blinkController.add(1);
  }

  void dispose() {
    _safetyTimer?.cancel();
    _distanceController.close();
    _blinkController.close();
  }
}
