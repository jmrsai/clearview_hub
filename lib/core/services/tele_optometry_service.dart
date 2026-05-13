import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter/material.dart';

class TeleOptometryService {
  static final TeleOptometryService _instance = TeleOptometryService._internal();
  factory TeleOptometryService() => _instance;
  TeleOptometryService._internal();

  bool _isInitialized = false;

  /// Initialize Zoom Video SDK
  Future<void> initialize({
    required String sdkKey,
    required String sdkSecret,
  }) async {
    if (_isInitialized) return;

    InitConfig options = InitConfig(
      domain: "zoom.us",
      enableLog: true,
    );

    try {
      await ZoomVideoSdkPlatform.instance.initSdk(options);
      _isInitialized = true;
      debugPrint('Zoom Video SDK Initialized');
    } catch (e) {
      debugPrint('Zoom Initialization Error: $e');
    }
  }

  /// Join a tele-optometry consultation session
  Future<void> joinConsultation({
    required String sessionName,
    required String token,
    required String userName,
  }) async {
    if (!_isInitialized) {
      debugPrint('Zoom SDK not initialized');
      return;
    }

    JoinSessionConfig params = JoinSessionConfig(
      sessionName: sessionName,
      token: token,
      userName: userName,
    );

    try {
      await ZoomVideoSdkPlatform.instance.joinSession(params);
    } catch (e) {
      debugPrint('Error joining Zoom session: $e');
    }
  }

  /// Leave the session
  Future<void> endConsultation() async {
    await ZoomVideoSdkPlatform.instance.leaveSession(false);
  }
}
