import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';

/// Core AI Vision Service to handle Face Detection, Blink Tracking, and Fatigue.
/// This abstracts ML Kit and Camera dependencies so we can easily swap in
/// TensorFlow Lite models in the future.
class AiVisionService {
  final Logger _logger = Logger();
  
  CameraController? _cameraController;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true, // Needed for blink (eye open probability)
      enableTracking: true, // Needed for continuous tracking
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isProcessing = false;
  int _blinkCount = 0;
  DateTime? _lastBlinkTime;
  
  /// Stream of blink events for UI/Gamification integration
  final StreamController<int> _blinkStreamController = StreamController.broadcast();
  Stream<int> get blinkStream => _blinkStreamController.stream;

  /// Stream to warn users if they are too close to the screen
  final StreamController<bool> _proximityWarningController = StreamController.broadcast();
  Stream<bool> get proximityWarningStream => _proximityWarningController.stream;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    // Prioritize front camera for eye tracking
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.low, // Low resolution is enough for face tracking and saves battery
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // Best for ML processing on Android
    );

    await _cameraController!.initialize();
    _logger.i('AI Vision Camera Initialized');
  }

  Future<void> startTracking() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      throw Exception('Camera not initialized. Call initialize() first.');
    }

    _cameraController!.startImageStream((CameraImage image) {
      if (_isProcessing) return;
      _isProcessing = true;
      _processImage(image);
    });
  }

  Future<void> _processImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      
      // Note: Rotation calculation depends on device orientation. 
      // For simplicity in this abstraction, assuming portrait.
      final inputImageRotation = InputImageRotation.rotation270deg; 

      final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      final inputImageData = InputImageMetadata(
        size: imageSize,
        rotation: inputImageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        _analyzeFace(face);
      }
    } catch (e) {
      _logger.e('Error processing image for AI Vision: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void _analyzeFace(Face face) {
    // 1. Blink Detection
    if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
      final leftOpen = face.leftEyeOpenProbability! > 0.4;
      final rightOpen = face.rightEyeOpenProbability! > 0.4;

      if (!leftOpen && !rightOpen) {
        final now = DateTime.now();
        if (_lastBlinkTime == null || now.difference(_lastBlinkTime!) > const Duration(milliseconds: 300)) {
          _blinkCount++;
          _lastBlinkTime = now;
          _blinkStreamController.add(_blinkCount);
        }
      }
    }

    // 2. Proximity/Distance Warning
    // Rough heuristic: If bounding box width takes up > 80% of image width, user is too close.
    // In a real app, this needs calibration based on camera focal length.
    if (_cameraController != null) {
        final imageWidth = _cameraController!.value.previewSize?.width ?? 480;
        final faceWidthRatio = face.boundingBox.width / imageWidth;
        
        if (faceWidthRatio > 0.8) {
          _proximityWarningController.add(true);
        } else {
          _proximityWarningController.add(false);
        }
    }
  }

  Future<void> stopTracking() async {
    if (_cameraController?.value.isStreamingImages ?? false) {
      await _cameraController?.stopImageStream();
    }
  }

  Future<void> dispose() async {
    await stopTracking();
    await _cameraController?.dispose();
    await _faceDetector.close();
    await _blinkStreamController.close();
    await _proximityWarningController.close();
    _logger.i('AI Vision Service Disposed');
  }
}
