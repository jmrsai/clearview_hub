import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class EyeStrainService {
  int _blinkCount = 0;
  int get blinkCount => _blinkCount;

  DateTime? _lastBlinkTime;

  /// Track blinks using eye open probabilities from ML Kit
  void processFace(Face face) {
    if (face.leftEyeOpenProbability != null &&
        face.rightEyeOpenProbability != null) {
      final leftOpen = face.leftEyeOpenProbability! > 0.5;
      final rightOpen = face.rightEyeOpenProbability! > 0.5;

      if (!leftOpen && !rightOpen) {
        // Eyes closed (Blink start)
        _lastBlinkTime = DateTime.now();
      } else if (leftOpen && rightOpen && _lastBlinkTime != null) {
        // Eyes reopened (Blink complete)
        _blinkCount++;
        _lastBlinkTime = null;
      }
    }
  }

  /// Calculates blink rate (blinks per minute)
  double getBlinksPerMinute(Duration sessionDuration) {
    if (sessionDuration.inSeconds == 0) return 0;
    return (_blinkCount / sessionDuration.inSeconds) * 60;
  }

  /// Suggests a break if blink rate is too low (standard is 15-20 bpm, screen use drops it to 5-7)
  bool shouldSuggestBreak(double bpm) {
    return bpm < 8.0;
  }

  void reset() {
    _blinkCount = 0;
    _lastBlinkTime = null;
  }
}
