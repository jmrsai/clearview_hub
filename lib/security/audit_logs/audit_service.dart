import 'package:hive/hive.dart';

class SecurityAuditService {
  static const String _boxName = 'security_audit_logs';

  Future<void> logEvent({
    required String action,
    required String userId,
    String? details,
  }) async {
    final box = await Hive.openBox(_boxName);
    final log = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': action,
      'userId': userId,
      'details': details,
      'device_id': 'unique_device_identifier', // TODO: Get device ID
    };
    await box.add(log);
    print('SECURITY AUDIT: $log');
  }

  Future<List<dynamic>> getLogs() async {
    final box = await Hive.openBox(_boxName);
    return box.values.toList();
  }
}
