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

import 'package:flutter/material.dart';
import 'package:eye_tracking/eye_tracking.dart';
import 'package:eye_tracking/eye_tracking_platform_interface.dart';
import 'package:clearview_hub/core/services/eye_tracking_service.dart';

class EyeCalibrationScreen extends StatefulWidget {
  final VoidCallback onCalibrationComplete;

  const EyeCalibrationScreen({super.key, required this.onCalibrationComplete});

  @override
  State<EyeCalibrationScreen> createState() => _EyeCalibrationScreenState();
}

class _EyeCalibrationScreenState extends State<EyeCalibrationScreen> {
  final EyeTrackingService _eyeTrackingService = EyeTrackingService();
  List<CalibrationPoint> _points = [];
  int _currentPointIndex = 0;
  bool _isCalibrating = false;
  double _calibrationAccuracy = 0.0;
  bool _calibrationFinished = false;

  @override
  void initState() {
    super.initState();
    _initCalibration();
  }

  Future<void> _initCalibration() async {
    await _eyeTrackingService.initialize();
    bool hasPermission = await _eyeTrackingService.requestPermission();
    if (!hasPermission) {
      // Handle permission denied
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = MediaQuery.of(context).size;
      _points = EyeTracking.createStandardCalibration(
        screenWidth: size.width,
        screenHeight: size.height,
      );

      setState(() {
        _isCalibrating = true;
      });

      await _eyeTrackingService.startCalibration(_points);
      _processNextPoint();
    });
  }

  Future<void> _processNextPoint() async {
    if (_currentPointIndex < _points.length) {
      // Wait for 2 seconds while the user stares at the point
      await Future.delayed(const Duration(seconds: 2));
      await _eyeTrackingService.addCalibrationPoint(_points[_currentPointIndex]);
      
      setState(() {
        _currentPointIndex++;
      });
      
      if (_currentPointIndex < _points.length) {
        _processNextPoint();
      } else {
        await _finishCalibration();
      }
    }
  }

  Future<void> _finishCalibration() async {
    await _eyeTrackingService.finishCalibration();
    double accuracy = await _eyeTrackingService.getCalibrationAccuracy();
    
    setState(() {
      _isCalibrating = false;
      _calibrationAccuracy = accuracy;
      _calibrationFinished = true;
    });

    if (accuracy > 0.7) {
      // Acceptable accuracy, complete
      Future.delayed(const Duration(seconds: 2), () {
        widget.onCalibrationComplete();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCalibrating && !_calibrationFinished) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_calibrationFinished) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _calibrationAccuracy > 0.7 ? Icons.check_circle : Icons.error,
                color: _calibrationAccuracy > 0.7 ? Colors.green : Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Calibration Accuracy: ${(_calibrationAccuracy * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              if (_calibrationAccuracy <= 0.7)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPointIndex = 0;
                      _calibrationFinished = false;
                    });
                    _initCalibration();
                  },
                  child: const Text('Retry Calibration'),
                ),
            ],
          ),
        ),
      );
    }

    final currentPoint = _points[_currentPointIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: currentPoint.x - 20,
            top: currentPoint.y - 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Please stare at the red dot',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Note: Do not dispose EyeTrackingService here if it's used globally
    super.dispose();
  }
}
