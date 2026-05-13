/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:async';
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
    final count = await db.rawQuery('SELECT COUNT(*) FROM vision_test_results WHERE sync_status = "pending"');
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
        final testId = test.id;
        if (success && testId != null) {
          await db.updateSyncStatus(testId, 'synced');
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
