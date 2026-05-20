import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// System to handle local caching, lazy loading, and background sync logic
class PerformanceOptimizer {
  late Box _cacheBox;

  Future<void> init() async {
    _cacheBox = await Hive.openBox('performance_cache');
  }

  /// Caches data with a TTL (Time To Live)
  Future<void> cacheData(String key, dynamic data, Duration ttl) async {
    await _cacheBox.put(key, {
      'data': data,
      'expiry': DateTime.now().add(ttl).toIso8601String(),
    });
  }

  /// Retrieves cached data if it's still valid
  dynamic getCachedData(String key) {
    final cached = _cacheBox.get(key) as Map<dynamic, dynamic>?;
    if (cached == null) return null;

    final expiry = DateTime.parse(cached['expiry']);
    if (DateTime.now().isAfter(expiry)) {
      _cacheBox.delete(key);
      return null;
    }

    return cached['data'];
  }

  /// Clears expired cache to save memory
  Future<void> cleanCache() async {
    final keysToDelete = [];
    for (var key in _cacheBox.keys) {
      final cached = _cacheBox.get(key) as Map<dynamic, dynamic>?;
      if (cached != null) {
        final expiry = DateTime.parse(cached['expiry']);
        if (DateTime.now().isAfter(expiry)) {
          keysToDelete.add(key);
        }
      }
    }

    for (var key in keysToDelete) {
      await _cacheBox.delete(key);
    }
  }
}

final performanceOptimizerProvider = Provider((ref) => PerformanceOptimizer());
