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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

/// Manages medication alarms, scheduling, and tracking.
class MedicationReminderService {
  MedicationReminderService._();
  static final MedicationReminderService instance = MedicationReminderService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => AuthService.instance.userId;

  static const _channelId = 'medication_reminders';
  static const _channelName = 'Medication Reminders';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle action: take, snooze, skip
    final payload = response.payload ?? '';
    if (payload.startsWith('take:')) {
      final reminderId = payload.replaceFirst('take:', '');
      markTaken(reminderId);
    }
  }

  /// Schedule daily alarms for a medication reminder.
  Future<void> scheduleReminder(MedicationReminder reminder) async {
    // Cancel any existing alarms for this reminder
    await cancelReminder(reminder.id);

    // Save to Firestore
    if (_uid != null) {
      await _db
          .collection('medications')
          .doc(_uid)
          .collection('reminders')
          .doc(reminder.id)
          .set(reminder.toMap());
    }

    // Schedule local alarms for each time slot
    for (int i = 0; i < reminder.times.length; i++) {
      final time = reminder.times[i];
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final notifId = _notifId(reminder.id, i);
      final scheduled = _nextScheduledTime(hour, minute);

      await _notifications.zonedSchedule(
        id: notifId,
        title: '💊 Medication Reminder',
        body: 'Time to take ${reminder.medicineName} ${reminder.dosage}',
        scheduledDate: scheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.max,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            actions: [
              const AndroidNotificationAction('take', '✅ Taken'),
              const AndroidNotificationAction('snooze', '⏰ Snooze 10min'),
            ],
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
        payload: 'take:${reminder.id}',
      );
    }
  }

  tz.TZDateTime _nextScheduledTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  int _notifId(String reminderId, int index) {
    return '${reminderId}_$index'.hashCode.abs() % 100000;
  }

  /// Cancel all alarms for a reminder.
  Future<void> cancelReminder(String reminderId) async {
    for (int i = 0; i < 5; i++) {
      await _notifications.cancel(id: _notifId(reminderId, i));
    }
    if (_uid != null) {
      await _db.collection('medications').doc(_uid).collection('reminders').doc(reminderId).delete();
    }
  }

  /// Mark a medication as taken.
  Future<void> markTaken(String reminderId) async {
    if (_uid == null) return;
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _db
        .collection('medications')
        .doc(_uid)
        .collection('reminders')
        .doc(reminderId)
        .collection('adherence')
        .doc(today)
        .set({'taken': true, 'timestamp': FieldValue.serverTimestamp()});
  }

  /// Get all active reminders for current user.
  Stream<List<MedicationReminder>> getReminders() {
    if (_uid == null) return const Stream.empty();
    return _db
        .collection('medications')
        .doc(_uid)
        .collection('reminders')
        .where('is_active', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => MedicationReminder.fromMap(d.data())).toList());
  }

  /// Schedule all active reminders (call on app startup).
  Future<void> scheduleAllActiveReminders() async {
    if (_uid == null) return;
    final snap = await _db
        .collection('medications')
        .doc(_uid)
        .collection('reminders')
        .where('is_active', isEqualTo: true)
        .get();
    for (final doc in snap.docs) {
      final reminder = MedicationReminder.fromMap(doc.data());
      await scheduleReminder(reminder);
    }
  }
}

/// Data model for a medication reminder.
class MedicationReminder {
  final String id;
  final String medicineName;
  final String dosage;
  final String frequency;
  final List<String> times;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? notes;

  MedicationReminder({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicine_name': medicineName,
    'dosage': dosage,
    'frequency': frequency,
    'times': times,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'is_active': isActive,
    'notes': notes,
  };

  factory MedicationReminder.fromMap(Map<String, dynamic> m) => MedicationReminder(
    id: m['id'] as String,
    medicineName: m['medicine_name'] as String,
    dosage: m['dosage'] as String,
    frequency: m['frequency'] as String,
    times: List<String>.from(m['times'] ?? []),
    startDate: DateTime.parse(m['start_date'] as String),
    endDate: m['end_date'] != null ? DateTime.parse(m['end_date'] as String) : null,
    isActive: m['is_active'] as bool? ?? true,
    notes: m['notes'] as String?,
  );

  String get frequencyLabel {
    switch (frequency) {
      case 'twice_daily': return 'Twice daily';
      case 'thrice_daily': return 'Three times daily';
      case 'four_times_daily': return 'Four times daily';
      case 'as_needed': return 'As needed';
      default: return 'Once daily';
    }
  }
}
