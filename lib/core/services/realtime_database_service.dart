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

import 'package:firebase_database/firebase_database.dart';
import 'auth_service.dart';

/// Service for interacting with Firebase Realtime Database.
/// Best for real-time status updates, live session tracking, and low-latency data.
class RealtimeDatabaseService {
  RealtimeDatabaseService._();
  static final RealtimeDatabaseService instance = RealtimeDatabaseService._();

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  String? get _uid => AuthService.instance.userId;

  DatabaseReference get _userPresenceRef => _db.ref('presence/$_uid');
  DatabaseReference get _liveSessionsRef => _db.ref('live_sessions/$_uid');

  /// Update the user's online status.
  Future<void> setUserPresence(bool isOnline) async {
    if (_uid == null) return;
    await _userPresenceRef.set({
      'is_online': isOnline,
      'last_seen': ServerValue.timestamp,
    });
  }

  /// Start a live vision therapy session.
  Future<void> startLiveSession(String sessionType) async {
    if (_uid == null) return;
    await _liveSessionsRef.set({
      'type': sessionType,
      'status': 'active',
      'started_at': ServerValue.timestamp,
    });
  }

  /// Update live session progress (e.g. current score in a game).
  Future<void> updateLiveSessionProgress(Map<String, dynamic> progress) async {
    if (_uid == null) return;
    await _liveSessionsRef.update({
      'progress': progress,
      'updated_at': ServerValue.timestamp,
    });
  }

  /// End the current live session.
  Future<void> endLiveSession() async {
    if (_uid == null) return;
    await _liveSessionsRef.remove();
  }

  /// Stream of the user's presence status.
  Stream<DatabaseEvent> get presenceStream {
    if (_uid == null) return const Stream.empty();
    return _userPresenceRef.onValue;
  }
}
