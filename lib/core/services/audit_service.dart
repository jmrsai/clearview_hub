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

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/database_helper.dart';
import 'auth_service.dart';


/// Service for medical audit logging (HIPAA/GDPR compliance).
/// Logs sensitive user actions to both local DB and Firestore.
class AuditService {
  AuditService._();
  static final AuditService instance = AuditService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Log a sensitive action.
  Future<void> logAction({
    required String action,
    required String resource,
    String? details,
  }) async {
    final userId = AuthService.instance.userId ?? 'anonymous';
    final timestamp = DateTime.now().toIso8601String();

    final logData = {
      'user_id': userId,
      'action': action,
      'resource': resource,
      'timestamp': timestamp,
      'details': details,
    };

    // 1. Log locally for offline persistence
    try {
      await DatabaseHelper.instance.insertAuditLog({
        ...logData,
        'sync_status': 'pending',
      });
    } catch (e) {
      dev.log('Local audit log failed: $e', name: 'AuditService', error: e);
    }

    // 2. Log to Firestore if online
    if (AuthService.instance.isAuthenticated) {
      try {
        await _db.collection('audit_logs').add({
          ...logData,
          'platform': 'mobile',
        });
      } catch (e) {
        dev.log('Remote audit log failed: $e', name: 'AuditService', error: e);
      }
    }
  }

  // Common actions for easier logging
  Future<void> logLogin() => logAction(action: 'LOGIN', resource: 'AUTH');
  Future<void> logLogout() => logAction(action: 'LOGOUT', resource: 'AUTH');
  Future<void> logDataAccess(String patientId) => logAction(action: 'DATA_ACCESS', resource: 'PATIENT_$patientId');
  Future<void> logDiagnostic(String testId) => logAction(action: 'DIAGNOSTIC_EXEC', resource: 'TEST_$testId');
}
