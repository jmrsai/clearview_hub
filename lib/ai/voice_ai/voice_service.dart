import 'package:flutter_tts/flutter_tts.dart';

class VoiceAiService {
  final FlutterTts _tts = FlutterTts();

  /// Converts AI health insights into spoken feedback.
  Future<void> speakInsight(String insight) async {
    await _tts.speak(insight);
  }

  /// Specialized voice for senior mode.
  Future<void> configureForSeniors() async {
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(0.9);
  }
}
