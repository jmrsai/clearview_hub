import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SmartNotificationService {
  static final SmartNotificationService _instance = SmartNotificationService._internal();
  factory SmartNotificationService() => _instance;
  SmartNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  Future<void> showEyeBreakAlert() async {
    const androidDetails = AndroidNotificationDetails(
      'eye_health_channel',
      'Eye Health Alerts',
      channelDescription: 'Reminders for 20-20-20 rule and eye breaks',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(
      0,
      'Time for an Eye Break! 👀',
      'Look at something 20 feet away for 20 seconds.',
      notificationDetails,
    );
  }

  Future<void> showPostureWarning() async {
    const androidDetails = AndroidNotificationDetails(
      'posture_channel',
      'Posture Warnings',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

    await _notificationsPlugin.show(
      1,
      'Fix Your Posture! 🧍',
      'Your neck is tilting too far forward. Sit up straight.',
      notificationDetails,
    );
  }
}
