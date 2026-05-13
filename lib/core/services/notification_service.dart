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

import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

/// Local notification service for medication reminders and eye exercise alerts.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );
    _initialized = true;
  }

  void _onTap(NotificationResponse response) {}

  // ── Medication Reminders ──────────────────────────────────────────────────

  Future<void> scheduleDailyMedicationReminder({
    required int id,
    required String medicationName,
    required String dosage,
    required int hour,
    required int minute,
  }) async {
    await initialize();
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: '💊 Daily Medication',
      body: 'Time to take $dosage of $medicationName',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_daily_channel',
          'Daily Medication Reminders',
          channelDescription: 'Daily recurring medication reminders',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF00D4FF),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'medication_daily:$id',
    );
  }

  // ── Eye Exercise Reminders ────────────────────────────────────────────────

  Future<void> scheduleEyeExerciseReminder({
    required int id,
    required int hour,
    required int minute,
    String exerciseName = '20-20-20 Rule',
  }) async {
    await initialize();
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: '👁️ Eye Exercise Time',
      body: 'Look away from your screen — $exerciseName',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'exercise_channel',
          'Eye Exercise Reminders',
          channelDescription: 'Daily eye exercise and break reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: const Color(0xFF10B981),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'exercise:$id',
    );
  }

  // ── Proximity Alert ───────────────────────────────────────────────────────

  Future<void> showProximityAlert(String severity) async {
    await initialize();
    await _plugin.show(
      id: 9999,
      title: severity == 'critical' ? '🚨 Too Close!' : '⚠️ Move Back',
      body: severity == 'critical'
          ? 'You are dangerously close to the screen!'
          : 'You are too close to the screen. Please move back.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'proximity_channel',
          'Proximity Alerts',
          channelDescription: 'Alerts when user is too close to screen',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
    );
  }

  // ── Utilities ─────────────────────────────────────────────────────────────

  Future<void> cancelNotification(int id) async => _plugin.cancel(id: id);
  Future<void> cancelAll() async => _plugin.cancelAll();
  Future<List<ActiveNotification>> getActiveNotifications() async =>
      _plugin.getActiveNotifications();
}
