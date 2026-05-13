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

import 'package:flutter/foundation.dart';

/// In-memory cache for AI responses to reduce API calls and improve UX.
///
/// Uses LRU eviction with a configurable max size and TTL.
class CacheService {
  CacheService._();
  static final CacheService instance = CacheService._();

  static const int _maxSize = 100;
  static const Duration _defaultTtl = Duration(hours: 4);

  final _store = <String, _CacheEntry>{};

  /// Store a value with an optional TTL.
  void put(String key, String value, {Duration? ttl}) {
    if (_store.length >= _maxSize) {
      // Evict oldest entry (LRU)
      _store.remove(_store.keys.first);
    }
    _store[key] = _CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? _defaultTtl),
    );
    debugPrint('[CacheService] Cached: ${key.substring(0, key.length.clamp(0, 40))}...');
  }

  /// Retrieve a cached value, or null if expired/missing.
  String? get(String key) {
    final entry = _store[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _store.remove(key);
      return null;
    }
    // Move to end (mark as recently used)
    _store.remove(key);
    _store[key] = entry;
    return entry.value;
  }

  /// Generate a cache key from a prompt (truncated hash).
  String keyFor(String prompt) {
    // Simple but effective: use a normalized version of the prompt
    final normalized = prompt.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return normalized.hashCode.toRadixString(36);
  }

  /// Remove all cached entries.
  void clear() => _store.clear();

  /// Cache stats for debugging.
  int get size => _store.length;

  /// Returns true if the key is cached and not expired.
  bool has(String key) => get(key) != null;
}

class _CacheEntry {
  final String value;
  final DateTime expiresAt;
  const _CacheEntry({required this.value, required this.expiresAt});
}

/// Rate limiter for AI API calls — prevents spam and excess costs.
///
/// Enforces a sliding window limit (e.g. max 10 requests per minute).
class RateLimitService {
  RateLimitService._();
  static final RateLimitService instance = RateLimitService._();

  static const int _maxRequestsPerWindow = 10;
  static const Duration _windowDuration = Duration(minutes: 1);

  final _timestamps = <DateTime>[];

  /// Returns true if a request is allowed right now.
  bool isAllowed() {
    final now = DateTime.now();
    final windowStart = now.subtract(_windowDuration);
    // Remove timestamps outside the window
    _timestamps.removeWhere((t) => t.isBefore(windowStart));

    if (_timestamps.length >= _maxRequestsPerWindow) {
      debugPrint('[RateLimit] ⚠️ Rate limit hit — ${_timestamps.length}/$_maxRequestsPerWindow requests in window.');
      return false;
    }
    _timestamps.add(now);
    return true;
  }

  /// How many seconds until the next request is allowed.
  int get secondsUntilReset {
    if (_timestamps.isEmpty) return 0;
    final oldest = _timestamps.first;
    final resetAt = oldest.add(_windowDuration);
    final diff = resetAt.difference(DateTime.now()).inSeconds;
    return diff.clamp(0, 60);
  }

  /// Current request count in this window.
  int get currentCount => _timestamps.length;

  /// Max allowed requests per window.
  int get maxRequests => _maxRequestsPerWindow;
}

/// Input sanitizer — prevents prompt injection and XSS in AI inputs.
class InputSanitizer {
  InputSanitizer._();

  /// Sanitize user input before sending to AI.
  /// Removes injection attempts and limits length.
  static String sanitize(String input, {int maxLength = 1000}) {
    var cleaned = input.trim();

    // Enforce length limit
    if (cleaned.length > maxLength) {
      cleaned = '${cleaned.substring(0, maxLength)}...';
    }

    // Remove common prompt injection patterns
    cleaned = cleaned
        .replaceAll(RegExp(r'ignore (all )?previous instructions?', caseSensitive: false), '[removed]')
        .replaceAll(RegExp(r'you are now', caseSensitive: false), '[removed]')
        .replaceAll(RegExp(r'disregard', caseSensitive: false), '[removed]')
        .replaceAll(RegExp(r'<[^>]*>', caseSensitive: false), '') // strip HTML
        .replaceAll(RegExp(r'\{[^}]*\}'), ''); // strip template injections

    return cleaned.trim();
  }

  /// Validate that input is not empty and meets minimum length.
  static bool isValid(String input, {int minLength = 2}) {
    final cleaned = input.trim();
    return cleaned.isNotEmpty && cleaned.length >= minLength;
  }
}
