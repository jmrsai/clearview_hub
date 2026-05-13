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
import 'package:flutter/material.dart';

/// Service that monitors network connectivity and exposes offline/online state.
class ConnectivityService extends ChangeNotifier {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  Future<void> initialize() async {
    final results = await Connectivity().checkConnectivity();
    _isOnline = _hasConnection(results);

    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final wasOnline = _isOnline;
      _isOnline = _hasConnection(results);
      if (wasOnline != _isOnline) notifyListeners();
    });
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Widget that shows a connectivity status banner at the top of any screen.
class ConnectivityBanner extends StatelessWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        final isOnline = ConnectivityService.instance.isOnline;
        return Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isOnline ? 0 : 30,
            color: const Color(0xFFF43F5E),
            child: isOnline
                ? const SizedBox.shrink()
                : const Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 14),
                      SizedBox(width: 8),
                      Text('Offline — Data will sync when reconnected',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ]),
                  ),
          ),
          Expanded(child: child),
        ]);
      },
    );
  }
}

/// Compact connectivity chip for app bars.
class ConnectivityChip extends StatelessWidget {
  const ConnectivityChip({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        final isOnline = ConnectivityService.instance.isOnline;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: isOnline ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: (isOnline ? const Color(0xFF10B981) : const Color(0xFFF43F5E)).withAlpha(120),
                  blurRadius: 6, spreadRadius: 1,
                )],
              ),
            ),
            const SizedBox(width: 5),
            Text(isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  color: isOnline ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                  fontSize: 11, fontWeight: FontWeight.w600,
                )),
          ]),
        );
      },
    );
  }
}
