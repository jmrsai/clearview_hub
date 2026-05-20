import 'package:hive/hive.dart';

class RetryQueueService {
  static const String _boxName = 'sync_retry_queue';

  /// Adds a pending data synchronization task to the local queue.
  Future<void> queueTask({
    required String endpoint,
    required Map<String, dynamic> data,
    String method = 'POST',
  }) async {
    final box = await Hive.openBox(_boxName);
    final task = {
      'timestamp': DateTime.now().toIso8601String(),
      'endpoint': endpoint,
      'data': data,
      'method': method,
      'attempts': 0,
    };
    await box.add(task);
  }

  /// Processes the pending tasks in the queue when internet is available.
  Future<void> processQueue(
    Future<bool> Function(Map<String, dynamic> task) processor,
  ) async {
    final box = await Hive.openBox(_boxName);
    final tasks = box.toMap();

    for (var key in tasks.keys) {
      final task = Map<String, dynamic>.from(tasks[key]);
      final success = await processor(task);

      if (success) {
        await box.delete(key);
      } else {
        // Increment attempts or handle backoff
        task['attempts'] += 1;
        await box.put(key, task);
      }
    }
  }
}
