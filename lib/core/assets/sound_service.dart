import 'package:audioplayers/audioplayers.dart';
import '../assets/assets_manager.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();

  Future<void> playSuccess() async {
    await _player.play(AssetSource(AppAssets.chimeSuccess));
  }

  Future<void> playAlert() async {
    await _player.play(AssetSource(AppAssets.alertWarning));
  }

  Future<void> playBreakReminder() async {
    await _player.play(AssetSource(AppAssets.breakReminder));
  }

  Future<void> startRelaxationMusic() async {
    await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
    await _ambientPlayer.play(AssetSource(AppAssets.relaxationMusic));
  }

  Future<void> stopAmbient() async {
    await _ambientPlayer.stop();
  }

  void dispose() {
    _player.dispose();
    _ambientPlayer.dispose();
  }
}
