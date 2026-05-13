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

import 'package:eye_tracking/eye_tracking.dart';
import 'package:eye_tracking/eye_tracking_platform_interface.dart';
import 'package:flutter/foundation.dart';

class EyeTrackingService {
  static final EyeTrackingService _instance = EyeTrackingService._internal();
  factory EyeTrackingService() => _instance;
  EyeTrackingService._internal();

  final EyeTracking _eyeTracking = EyeTracking();
  bool _isInitialized = false;
  bool _isTracking = false;

  bool get isInitialized => _isInitialized;
  bool get isTracking => _isTracking;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _eyeTracking.initialize();
      return _isInitialized;
    } catch (e) {
      debugPrint('EyeTrackingService initialization failed: $e');
      return false;
    }
  }

  Future<bool> requestPermission() async {
    return await _eyeTracking.requestCameraPermission();
  }

  Future<void> startTracking() async {
    if (!_isInitialized) return;
    try {
      await _eyeTracking.startTracking();
      _isTracking = true;
    } catch (e) {
      debugPrint('Failed to start tracking: $e');
    }
  }

  Future<void> stopTracking() async {
    if (!_isTracking) return;
    try {
      await _eyeTracking.stopTracking();
      _isTracking = false;
    } catch (e) {
      debugPrint('Failed to stop tracking: $e');
    }
  }

  Stream<GazeData> get gazeStream => _eyeTracking.getGazeStream();
  Stream<EyeState> get eyeStateStream => _eyeTracking.getEyeStateStream();

  // Calibration Methods
  Future<void> startCalibration(List<CalibrationPoint> points) async {
    await _eyeTracking.startCalibration(points);
  }

  Future<void> addCalibrationPoint(CalibrationPoint point) async {
    await _eyeTracking.addCalibrationPoint(point);
  }

  Future<void> finishCalibration() async {
    await _eyeTracking.finishCalibration();
  }

  Future<double> getCalibrationAccuracy() async {
    return await _eyeTracking.getCalibrationAccuracy();
  }

  void dispose() {
    _eyeTracking.dispose();
  }
}
