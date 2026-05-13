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

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../utils/camera_utils.dart';

class BlinkDetectionService {
  BlinkDetectionService._();
  static final BlinkDetectionService instance = BlinkDetectionService._();

  CameraController? _controller;
  CameraDescription? _camera;
  FaceDetector? _faceDetector;
  bool _isProcessing = false;
  bool _isBlinking = false;
  
  final _blinkListeners = <void Function()>[];

  void addBlinkListener(void Function() listener) => _blinkListeners.add(listener);
  void removeBlinkListener(void Function() listener) => _blinkListeners.remove(listener);

  Future<void> start() async {
    final cameras = await availableCameras();
    _camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);

    _controller = CameraController(_camera!, ResolutionPreset.low, enableAudio: false);
    await _controller!.initialize();

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    _controller!.startImageStream(_processImage);
  }

  void _processImage(CameraImage image) async {
    if (_isProcessing || _faceDetector == null || _camera == null) return;
    _isProcessing = true;

    try {
      final inputImage = CameraUtils.convertCameraImage(image, _camera!);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);
      
      if (faces.isEmpty) {
        _isBlinking = false;
        return;
      }

      final face = faces.first;
      final double? leftOpen = face.leftEyeOpenProbability;
      final double? rightOpen = face.rightEyeOpenProbability;

      if (leftOpen != null && rightOpen != null) {
        // Average probability to handle winks or partial blinks
        final double avgOpen = (leftOpen + rightOpen) / 2.0;
        
        if (avgOpen < 0.2 && !_isBlinking) {
          _isBlinking = true;
          for (final l in _blinkListeners) {
            l();
          }
        } else if (avgOpen > 0.5) {
          _isBlinking = false;
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> stop() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    await _faceDetector?.close();
    _controller = null;
    _camera = null;
    _faceDetector = null;
  }
}
