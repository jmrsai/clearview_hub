import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ARFilter {
  final String id;
  final String name;
  final String assetPath;
  final ARFilterType type;

  ARFilter({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.type,
  });
}

enum ARFilterType {
  glassesTryOn, // Lenskart style
  relaxationAura, // Snapchat style wellness filter
  focusOverlay, // Highlight screen center
  fatigueSimulator, // Show how tired eyes look
}

/// Handles AR Overlays, Face Tracking, and Filters
class ARSystemEngine {
  final FaceDetector _faceDetector;

  ARSystemEngine()
    : _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          enableTracking: true,
          enableLandmarks: true,
        ),
      );

  Future<List<Face>> processImage(InputImage inputImage) async {
    return await _faceDetector.processImage(inputImage);
  }

  void dispose() {
    _faceDetector.close();
  }

  // Mock list of available AR Filters
  List<ARFilter> getAvailableFilters() {
    return [
      ARFilter(
        id: 'lens_1',
        name: 'Blue Light Blockers',
        assetPath: 'assets/models/glasses_1.obj',
        type: ARFilterType.glassesTryOn,
      ),
      ARFilter(
        id: 'relax_1',
        name: 'Zen Aura',
        assetPath: 'assets/animations/zen_aura.json',
        type: ARFilterType.relaxationAura,
      ),
      ARFilter(
        id: 'focus_1',
        name: 'Deep Focus',
        assetPath: 'assets/animations/focus_ring.json',
        type: ARFilterType.focusOverlay,
      ),
    ];
  }

  /// Calculates eye openness to trigger blink challenges
  bool isBlinking(Face face) {
    if (face.leftEyeOpenProbability != null &&
        face.rightEyeOpenProbability != null) {
      return face.leftEyeOpenProbability! < 0.2 &&
          face.rightEyeOpenProbability! < 0.2;
    }
    return false;
  }
}

final arSystemEngineProvider = Provider((ref) => ARSystemEngine());
