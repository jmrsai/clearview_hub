import 'dart:async';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';

class FaceMetrics {
  final double leftEyeOpenProbability;
  final double rightEyeOpenProbability;
  final double headEulerAngleY; // Yaw (turning head left/right)
  final double headEulerAngleZ; // Roll (tilting head left/right)
  final double headEulerAngleX; // Pitch (looking up/down - good for posture)
  final bool isBlinking;

  FaceMetrics({
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
    required this.headEulerAngleY,
    required this.headEulerAngleZ,
    required this.headEulerAngleX,
    required this.isBlinking,
  });
}

class MLKitFaceDetectorService {
  final FaceDetector _faceDetector;
  CameraController? _cameraController;
  bool _isProcessing = false;
  
  final StreamController<FaceMetrics> _metricsController = StreamController<FaceMetrics>.broadcast();
  Stream<FaceMetrics> get metricsStream => _metricsController.stream;

  MLKitFaceDetectorService()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableClassification: true, // Needed for eyes open/closed probability
            enableTracking: true,
            minFaceSize: 0.1,
            performanceMode: FaceDetectorMode.fast, // Save battery
          ),
        );

  Future<void> startDetection(CameraController cameraController) async {
    _cameraController = cameraController;
    if (!_cameraController!.value.isStreamingImages) {
      await _cameraController!.startImageStream((CameraImage image) {
        if (_isProcessing) return;
        _isProcessing = true;
        _processImage(image);
      });
    }
  }

  Future<void> _processImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;
      
      final planeData = image.planes.map(
        (Plane plane) {
          return InputImageMetadata(
            bytesPerRow: plane.bytesPerRow,
            size: Size(image.width.toDouble(), image.height.toDouble()),
            format: inputImageFormat,
            rotation: InputImageRotation.rotation0deg,
          );
        },
      ).toList();

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: planeData.first, // Uses first plane for metadata
      );

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
        final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;
        
        final isBlinking = leftEyeOpen < 0.2 && rightEyeOpen < 0.2;

        _metricsController.add(
          FaceMetrics(
            leftEyeOpenProbability: leftEyeOpen,
            rightEyeOpenProbability: rightEyeOpen,
            headEulerAngleY: face.headEulerAngleY ?? 0.0,
            headEulerAngleZ: face.headEulerAngleZ ?? 0.0,
            headEulerAngleX: face.headEulerAngleX ?? 0.0,
            isBlinking: isBlinking,
          ),
        );
      }
    } catch (e) {
      debugPrint("Face detection error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> stopDetection() async {
    if (_cameraController?.value.isStreamingImages ?? false) {
      await _cameraController?.stopImageStream();
    }
  }

  void dispose() {
    stopDetection();
    _metricsController.close();
    _faceDetector.close();
  }
}
