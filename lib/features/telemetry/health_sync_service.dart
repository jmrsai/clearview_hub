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
import 'package:health/health.dart';

/// Service responsible for syncing data with Apple HealthKit or Google Health Connect.
class HealthSyncService extends ChangeNotifier {
  static final HealthSyncService _instance = HealthSyncService._internal();
  factory HealthSyncService() => _instance;
  HealthSyncService._internal();

  final Health _health = Health();
  bool _isAuthorized = false;

  bool get isAuthorized => _isAuthorized;

  // The specific data types relevant to ophthalmic analysis
  final List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.BLOOD_GLUCOSE,
  ];

  Future<void> requestAuthorization() async {
    try {
      // Configure health before requesting
      _health.configure();
      
      bool authorized = await _health.requestAuthorization(_dataTypes);
      _isAuthorized = authorized;
      notifyListeners();
      
      if (authorized) {
        debugPrint("Health Connect / HealthKit Authorized.");
      } else {
        debugPrint("Health permissions denied.");
      }
    } catch (e) {
      debugPrint("Error requesting health auth: $e");
    }
  }

  /// Fetch blood glucose data for the past week (Crucial for Diabetic Retinopathy correlation)
  Future<List<HealthDataPoint>> fetchRecentBloodGlucose() async {
    if (!_isAuthorized) return [];
    
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    
    try {
      return await _health.getHealthDataFromTypes(
        startTime: lastWeek,
        endTime: now,
        types: [HealthDataType.BLOOD_GLUCOSE],
      );
    } catch (e) {
      debugPrint("Error fetching glucose: $e");
      return [];
    }
  }

  /// Fetch step count for today (proxy for physical activity/mobility)
  Future<int?> fetchTodaySteps() async {
    if (!_isAuthorized) return null;
    
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    
    try {
      return await _health.getTotalStepsInInterval(midnight, now);
    } catch (e) {
      debugPrint("Error fetching steps: $e");
      return null;
    }
  }
}
