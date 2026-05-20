import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDistanceService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  /// Estimates the distance from the screen in centimeters.
  /// This is a heuristic based on the average inter-pupillary distance.
  double estimateDistance(Face face, double frameHeight) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

    if (leftEye == null || rightEye == null) return -1.0;

    // Calculate pixel distance between eyes
    final dx = rightEye.position.x - leftEye.position.x;
    final dy = rightEye.position.y - leftEye.position.y;
    final pixelDistance = (dx * dx + dy * dy)
        .toDouble(); // sqrt taken later for efficiency or just use a threshold

    // Heuristic: Distance = (FocalLength * RealWidth) / PixelWidth
    // For a typical smartphone, FocalLength * RealWidth is roughly 2500-3000
    const double k = 2800.0;
    final distance = k / (dx.abs());

    return distance; // Returns approx cm
  }

  /// Warning threshold (e.g., 30cm)
  bool isTooClose(double distance) {
    return distance > 0 && distance < 30.0;
  }

  void dispose() {
    _faceDetector.close();
  }
}
