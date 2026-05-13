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
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/camera_utils.dart';

enum ProximityLevel { safe, warning, critical }

class ProximityStatus {
  final ProximityLevel level;
  final bool isLookingAtScreen;

  ProximityStatus({required this.level, required this.isLookingAtScreen});
}

class ProximityAlertService {
  ProximityAlertService._();
  static final ProximityAlertService instance = ProximityAlertService._();

  CameraController? _controller;
  CameraDescription? _camera;
  FaceDetector? _faceDetector;
  bool _isRunning = false;
  ProximityLevel _level = ProximityLevel.safe;
  bool _isLookingAtScreen = true;
  
  final _listeners = <void Function(ProximityStatus)>[];

  ProximityLevel get currentLevel => _level;
  bool get isLookingAtScreen => _isLookingAtScreen;
  bool get isRunning => _isRunning;

  void addListener(void Function(ProximityStatus) listener) => _listeners.add(listener);
  void removeListener(void Function(ProximityStatus) listener) => _listeners.remove(listener);

  Future<void> start() async {
    if (_isRunning) return;
    try {
      final cameras = await availableCameras();
      _camera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first);
      
      _controller = CameraController(_camera!, ResolutionPreset.low,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
      await _controller!.initialize();

      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true,
          enableLandmarks: false,
          enableTracking: true,
        ),
      );

      _isRunning = true;
      await _controller!.startImageStream(_processFrame);
    } catch (_) {
      _isRunning = false;
    }
  }

  Future<void> stop() async {
    _isRunning = false;
    await _controller?.stopImageStream();
    await _controller?.dispose();
    await _faceDetector?.close();
    _controller = null;
    _faceDetector = null;
    _updateStatus(ProximityLevel.safe, true);
  }

  int _frameCount = 0;
  bool _isProcessing = false;

  void _processFrame(CameraImage image) async {
    _frameCount++;
    if (_frameCount % 10 != 0 || _isProcessing || _faceDetector == null || _camera == null) return;
    _isProcessing = true;

    try {
      final inputImage = CameraUtils.convertCameraImage(image, _camera!);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);
      
      if (faces.isEmpty) {
        _updateStatus(ProximityLevel.safe, false); // No face detected = not looking
        return;
      }

      final face = faces.first;
      
      // Proximity detection using face bounding box size relative to frame
      final double faceArea = face.boundingBox.width * face.boundingBox.height;
      final double frameArea = (image.width * image.height).toDouble();
      final double ratio = faceArea / frameArea;

      ProximityLevel level;
      if (ratio > 0.45) { // Empirically determined threshold for "too close"
        level = ProximityLevel.critical;
      } else if (ratio > 0.3) {
        level = ProximityLevel.warning;
      } else {
        level = ProximityLevel.safe;
      }

      // Gaze/Attention detection: Check if eyes are open and face is not tilted
      bool looking = true;
      if (face.leftEyeOpenProbability != null && face.leftEyeOpenProbability! < 0.2 &&
          face.rightEyeOpenProbability != null && face.rightEyeOpenProbability! < 0.2) {
        looking = false; // Eyes closed
      }
      
      // Face orientation check (Head Euler Y/Z angles)
      if (face.headEulerAngleY != null && face.headEulerAngleY!.abs() > 25) {
        looking = false; // Turned away left/right
      }

      _updateStatus(level, looking);
    } catch (e) {
      debugPrint('Proximity analysis error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void _updateStatus(ProximityLevel level, bool looking) {
    if (level != _level || looking != _isLookingAtScreen) {
      _level = level;
      _isLookingAtScreen = looking;
      final status = ProximityStatus(level: _level, isLookingAtScreen: _isLookingAtScreen);
      for (final l in _listeners) {
        l(status);
      }
    }
  }

  void dispose() {
    stop();
    _listeners.clear();
  }
}

class ProximityAlertOverlay extends StatefulWidget {
  final Widget child;
  const ProximityAlertOverlay({super.key, required this.child});

  @override
  State<ProximityAlertOverlay> createState() => _ProximityAlertOverlayState();
}

class _ProximityAlertOverlayState extends State<ProximityAlertOverlay>
    with SingleTickerProviderStateMixin {
  ProximityStatus _status = ProximityStatus(level: ProximityLevel.safe, isLookingAtScreen: true);
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    ProximityAlertService.instance.addListener(_onStatusChange);
    ProximityAlertService.instance.start();
  }

  @override
  void dispose() {
    _pulse.dispose();
    ProximityAlertService.instance.removeListener(_onStatusChange);
    super.dispose();
  }

  void _onStatusChange(ProximityStatus status) {
    if (mounted) setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    final showProximity = _status.level != ProximityLevel.safe;
    final showGaze = !_status.isLookingAtScreen;

    return Stack(children: [
      widget.child,
      if (showProximity || showGaze)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16, right: 16,
          child: ScaleTransition(
            scale: _pulseAnim,
            child: _ProximityBanner(status: _status),
          ),
        ),
    ]);
  }
}

class _ProximityBanner extends StatelessWidget {
  final ProximityStatus status;
  const _ProximityBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final isCritical = status.level == ProximityLevel.critical;
    final isGazeLoss = !status.isLookingAtScreen;
    
    final color = isCritical || isGazeLoss ? AppColors.error : AppColors.warning;
    final icon = isGazeLoss ? Icons.visibility_off : (isCritical ? Icons.warning_amber_rounded : Icons.remove_red_eye);
    final message = isGazeLoss 
        ? '⚠️ Keep your eyes on the screen!' 
        : (isCritical ? '🚨 Too close! Move away.' : '⚠️ You\'re too close.');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: color.withAlpha(100), blurRadius: 12)],
      ),
      child: Row(children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
        )),
      ]),
    );
  }
}
