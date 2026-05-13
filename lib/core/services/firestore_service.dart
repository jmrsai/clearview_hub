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

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/patient.dart';
import '../../models/vision_test_result.dart';
import '../../models/user_roles.dart';
import 'auth_service.dart';
import 'audit_service.dart';

/// Service for interacting with Cloud Firestore.
/// Maps local models to Firestore collections.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => AuthService.instance.userId;

  CollectionReference get _patientsRef => _db.collection('users').doc(_uid).collection('patients');
  CollectionReference get _doctorsRef => _db.collection('doctors');
  CollectionReference get _adminsRef => _db.collection('administrators');

  /// Save doctor profile to Firestore.
  Future<void> saveDoctorProfile(Doctor doctor) async {
    await _doctorsRef.doc(doctor.uid).set(doctor.toMap());
    // Also update common user doc
    await _db.collection('users').doc(doctor.uid).set({
      'name': doctor.name,
      'email': doctor.email,
      'role': 'doctor',
    }, SetOptions(merge: true));
  }

  /// Save admin profile to Firestore.
  Future<void> saveAdminProfile(Administrator admin) async {
    await _adminsRef.doc(admin.uid).set(admin.toMap());
    await _db.collection('users').doc(admin.uid).set({
      'name': admin.name,
      'email': admin.email,
      'role': 'admin',
    }, SetOptions(merge: true));
  }

  /// Sync a patient to Firestore.
  Future<void> savePatient(Patient patient) async {
    if (_uid == null) return;
    await _patientsRef.doc(patient.id).set(patient.toMap());
  }

  /// Sync vision test result to Firestore.
  Future<void> saveVisionTestResult(VisionTestResult result) async {
    if (_uid == null) return;
    await _patientsRef
        .doc(result.patientId)
        .collection('vision_tests')
        .doc(result.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString())
        .set(result.toMap());
  }

  /// Get all patients from Firestore.
  Stream<List<Patient>> getPatients() {
    if (_uid == null) return const Stream.empty();
    AuditService.instance.logAction(action: 'LIST_PATIENTS', resource: 'PATIENTS_COLLECTION');
    return _patientsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Patient.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Delete patient from Firestore.
  Future<void> deletePatient(String patientId) async {
    if (_uid == null) return;
    await _patientsRef.doc(patientId).delete();
  }

  /// Bulk sync multiple results (e.g. from local database).
  Future<void> syncMultipleResults(List<VisionTestResult> results) async {
    if (_uid == null || results.isEmpty) return;
    
    final WriteBatch batch = _db.batch();
    for (final result in results) {
      final docRef = _patientsRef
          .doc(result.patientId)
          .collection('vision_tests')
          .doc(result.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString());
      batch.set(docRef, result.toMap());
    }
    await batch.commit();
  }

  /// Get vision test trends for a specific patient.
  Stream<List<VisionTestResult>> getVisionTestTrends(String patientId) {
    if (_uid == null) return const Stream.empty();
    AuditService.instance.logDataAccess(patientId);
    return _patientsRef
        .doc(patientId)
        .collection('vision_tests')
        .orderBy('performed_at', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => VisionTestResult.fromMap(doc.data())).toList();
    });
  }

  /// Get the current user's role from Firestore.
  Future<String?> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['role'] as String?;
    }
    return null;
  }
}
