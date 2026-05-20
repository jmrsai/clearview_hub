import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Handles Telegram-style offline-first Realtime Sync
class RealtimeSyncEngine {
  final Connectivity _connectivity = Connectivity();
  late Box _syncQueueBox;
  bool _isOnline = false;

  Future<void> init() async {
    _syncQueueBox = await Hive.openBox('sync_queue');

    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _isOnline =
          results.isNotEmpty && results.first != ConnectivityResult.none;
      if (_isOnline) {
        _processQueue();
      }
    });

    final results = await _connectivity.checkConnectivity();
    _isOnline = results.isNotEmpty && results.first != ConnectivityResult.none;
  }

  void queueAction(String actionType, Map<String, dynamic> payload) {
    if (_isOnline) {
      _executeActionOnline(actionType, payload);
    } else {
      _syncQueueBox.add({
        'action': actionType,
        'payload': payload,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _processQueue() async {
    if (_syncQueueBox.isEmpty) return;

    for (int i = 0; i < _syncQueueBox.length; i++) {
      final item = _syncQueueBox.getAt(i) as Map<dynamic, dynamic>;
      await _executeActionOnline(
        item['action'],
        Map<String, dynamic>.from(item['payload']),
      );
    }
    await _syncQueueBox.clear();
  }

  Future<void> _executeActionOnline(
    String actionType,
    Map<String, dynamic> payload,
  ) async {
    // In production: Push to Firebase RTDB or Supabase depending on actionType
    // e.g., if actionType == 'send_message', push to Firebase
  }
}

final realtimeSyncEngineProvider = Provider<RealtimeSyncEngine>((ref) {
  return RealtimeSyncEngine();
});
