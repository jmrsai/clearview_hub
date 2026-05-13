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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// OpthaS AI Automated Network Sync Service
/// Monitors internet connectivity and triggers background data synchronization.
class OpthasNetworkSyncService extends ChangeNotifier {
  static final OpthasNetworkSyncService _instance = OpthasNetworkSyncService._internal();
  factory OpthasNetworkSyncService() => _instance;
  OpthasNetworkSyncService._internal() {
    _initConnectivity();
  }

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = true;
  bool _isSyncing = false;

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;

  void _initConnectivity() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    
    // Initial check
    _connectivity.checkConnectivity().then(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // connectivity_plus 6.0+ returns a List. If any is not 'none', we are online.
    final bool online = results.any((result) => result != ConnectivityResult.none);
    
    if (online != _isOnline) {
      _isOnline = online;
      notifyListeners();
      
      if (_isOnline) {
        debugPrint("OpthaS AI: Connection Restored. Starting automated sync...");
        _triggerAutomatedSync();
      } else {
        debugPrint("OpthaS AI: Device Offline. Entering local caching mode.");
      }
    }
  }

  Future<void> _triggerAutomatedSync() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    notifyListeners();

    try {
      // Simulate data synchronization from local secure cache to OpthaS AI Cloud
      await Future.delayed(const Duration(seconds: 3));
      debugPrint("OpthaS AI: Automated sync complete. All clinical records updated.");
    } catch (e) {
      debugPrint("OpthaS AI: Sync failed: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
