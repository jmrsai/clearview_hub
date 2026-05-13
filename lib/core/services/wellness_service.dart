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

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Tracks digital wellness metrics: eye strain score, screen time, blink rate.
class WellnessService extends ChangeNotifier {
  WellnessService._();
  static final WellnessService instance = WellnessService._();

  // Metrics
  int _screenTimeMinutes = 0;
  int _blinkCount = 0;
  int _breaksTaken = 0;
  int _breaksRequired = 0;
  Timer? _screenTimer;
  bool _tracking = false;

  // Historical (last 7 days)
  final List<DailyWellness> _weeklyData = [];

  int get screenTimeMinutes => _screenTimeMinutes;
  int get blinkCount => _blinkCount;
  int get breaksTaken => _breaksTaken;
  bool get isTracking => _tracking;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _screenTimeMinutes = prefs.getInt('screen_time_today') ?? 0;
    _breaksTaken = prefs.getInt('breaks_today') ?? 0;
    _breaksRequired = prefs.getInt('breaks_required_today') ?? 0;
    _loadWeeklyData(prefs);
    startTracking();
  }

  void startTracking() {
    if (_tracking) return;
    _tracking = true;
    // Increment screen time every minute
    _screenTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _screenTimeMinutes++;
      _saveToday();
      notifyListeners();
    });
  }

  void stopTracking() {
    _screenTimer?.cancel();
    _tracking = false;
  }

  /// Called by blink detection service when a blink is detected.
  void recordBlink() {
    _blinkCount++;
    notifyListeners();
  }

  /// Called when user takes a 20-20-20 break.
  void recordBreak() {
    _breaksTaken++;
    _breaksRequired++;
    _saveToday();
    notifyListeners();
  }

  /// Eye strain score from 0 (great) to 100 (severe strain).
  int get eyeStrainScore {
    int score = 0;
    // Screen time component (max 40 points)
    final hours = _screenTimeMinutes / 60;
    score += (hours * 8).clamp(0, 40).toInt();
    // Blink rate component (max 30 points — low blink = more strain)
    final expectedBlinks = _screenTimeMinutes * 12; // ~12 blinks/min
    if (expectedBlinks > 0) {
      final blinkDeficit = ((expectedBlinks - _blinkCount) / expectedBlinks).clamp(0.0, 1.0);
      score += (blinkDeficit * 30).toInt();
    }
    // Break compliance component (max 30 points)
    if (_breaksRequired > 0) {
      final missedRatio = 1.0 - (_breaksTaken / _breaksRequired).clamp(0.0, 1.0);
      score += (missedRatio * 30).toInt();
    }
    return score.clamp(0, 100);
  }

  /// Strain level label.
  String get strainLabel {
    final s = eyeStrainScore;
    if (s < 25) return 'Excellent 🟢';
    if (s < 50) return 'Moderate 🟡';
    if (s < 75) return 'High 🟠';
    return 'Severe 🔴';
  }

  Color get strainColor {
    final s = eyeStrainScore;
    if (s < 25) return const Color(0xFF10B981);
    if (s < 50) return const Color(0xFFF59E0B);
    if (s < 75) return const Color(0xFFEF4444);
    return const Color(0xFF7C3AED);
  }

  /// Personalized suggestion based on current metrics.
  String get currentSuggestion {
    final s = eyeStrainScore;
    if (_screenTimeMinutes > 120 && _breaksTaken == 0) {
      return '⚠️ You have been using your screen for ${(_screenTimeMinutes / 60).toStringAsFixed(1)} hours without a break. Take a 5-minute rest now!';
    }
    if (_blinkCount < (_screenTimeMinutes * 8)) {
      return '👁️ Your blink rate is below normal. Remember to blink more often — try the 20-second blink exercise.';
    }
    if (s < 25) return '✅ Your eye health today looks great! Keep up the good habits.';
    if (s < 50) return '🟡 Moderate eye strain detected. Consider taking a 20-20-20 break soon.';
    return '🔴 High eye strain! Please take an extended break and do the eye exercises.';
  }

  /// Average blink rate per minute.
  double get blinkRatePerMinute {
    if (_screenTimeMinutes == 0) return 0;
    return _blinkCount / _screenTimeMinutes;
  }

  List<DailyWellness> get weeklyData => List.unmodifiable(_weeklyData);

  Future<void> _saveToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('screen_time_today', _screenTimeMinutes);
    await prefs.setInt('breaks_today', _breaksTaken);
    await prefs.setInt('breaks_required_today', _breaksRequired);
    // Save today's summary
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setInt('screen_time_$today', _screenTimeMinutes);
    await prefs.setInt('strain_$today', eyeStrainScore);
  }

  void _loadWeeklyData(SharedPreferences prefs) {
    _weeklyData.clear();
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = date.toIso8601String().split('T')[0];
      _weeklyData.add(DailyWellness(
        date: date,
        screenTimeMinutes: prefs.getInt('screen_time_$key') ?? 0,
        strainScore: prefs.getInt('strain_$key') ?? 0,
      ));
    }
  }

  @override
  void dispose() {
    _screenTimer?.cancel();
    super.dispose();
  }
}

class DailyWellness {
  final DateTime date;
  final int screenTimeMinutes;
  final int strainScore;
  DailyWellness({required this.date, required this.screenTimeMinutes, required this.strainScore});
  String get dayLabel {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }
}
