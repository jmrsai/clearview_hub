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
import '../../core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisionBreakService {
  VisionBreakService._();
  static final VisionBreakService instance = VisionBreakService._();

  Timer? _timer;
  bool _isActive = false;
  static const String _prefKey = 'vision_break_enabled';
  
  final _eventController = StreamController<void>.broadcast();
  Stream<void> get onBreakTriggered => _eventController.stream;

  bool get isActive => _isActive;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isActive = prefs.getBool(_prefKey) ?? false;
    if (_isActive) {
      start();
    }
  }

  Future<void> toggle(bool value) async {
    _isActive = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isActive);
    if (_isActive) {
      start();
    } else {
      stop();
    }
  }

  void start() {
    _timer?.cancel();
    // 20 minutes = 20 * 60 seconds
    _timer = Timer.periodic(const Duration(minutes: 20), (timer) {
      _sendReminder();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _sendReminder() {
    _eventController.add(null);
    NotificationService.instance.scheduleEyeExerciseReminder(
      id: 202020,
      hour: 0, // Not used for immediate/relative scheduling in this specific logic
      minute: 0,
      exerciseName: '20-20-20 Break: Look 20 feet away for 20 seconds!',
    );
    
    // Note: In a real implementation, we might want to use a more sophisticated 
    // scheduling method from NotificationService that supports relative intervals
    // or immediate "heads-up" notifications.
    NotificationService.instance.showProximityAlert('info'); // Reusing for demo
  }
}
