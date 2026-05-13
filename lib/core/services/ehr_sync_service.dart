import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import 'ehr_service.dart';

/// Manages a background queue for syncing clinical results to the EHR.
class EhrSyncService extends ChangeNotifier {
  EhrSyncService._();
  static final EhrSyncService instance = EhrSyncService._();

  bool _isSyncing = false;
  int _pendingCount = 0;

  bool get isSyncing => _isSyncing;
  int get pendingCount => _pendingCount;

  Timer? _syncTimer;

  /// Start the periodic sync worker.
  void start() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncNow());
    _updatePendingCount();
  }

  Future<void> _updatePendingCount() async {
    final db = await DatabaseHelper.instance.database;
    final count = await db.rawQuery('SELECT COUNT(*) FROM vision_tests WHERE sync_status = "pending"');
    _pendingCount = (count.first.values.first as int?) ?? 0;
    notifyListeners();
  }

  /// Manually trigger a synchronization of all pending results.
  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    try {
      final db = DatabaseHelper.instance;
      final pendingTests = await db.getPendingSyncTests();
      
      for (final test in pendingTests) {
        final success = await EhrService.instance.exportToFhir(test);
        if (success) {
          await db.updateSyncStatus(test.id, 'synced');
        }
      }
    } catch (e) {
      debugPrint('EHR Sync failed: $e');
    } finally {
      _isSyncing = false;
      await _updatePendingCount();
    }
  }

  void stop() {
    _syncTimer?.cancel();
  }
}
