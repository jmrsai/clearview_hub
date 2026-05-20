import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();

  bool _isListening = false;
  bool get isListening => _isListening;

  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    await _stt.initialize();
  }

  /// Speak text to the user
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  /// Start listening for voice commands
  Future<void> listen({required Function(String) onResult}) async {
    if (!_stt.isAvailable) {
      await speak('Speech recognition is not available on this device.');
      return;
    }

    _isListening = true;
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          _isListening = false;
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 3),
      cancelOnError: true,
      partialResults: false,
    );
  }

  Future<void> stopListening() async {
    await _stt.stop();
    _isListening = false;
  }

  void dispose() {
    _tts.stop();
  }
}
