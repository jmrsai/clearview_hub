import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/diagnostic_report.dart';
import '../../models/eye_twin_metrics.dart';
import '../../models/patient.dart';
import '../../models/vision_test_result.dart';

class DatabaseService {
  static const String _encryptionKeyName = 'eyeverse_hive_encryption_key';

  static const String patientsBoxName = 'patients';
  static const String diagnosticReportsBoxName = 'diagnostic_reports';
  static const String visionTestResultsBoxName = 'vision_test_results';
  static const String eyeTwinMetricsBoxName = 'eye_twin_metrics';

  final FlutterSecureStorage _secureStorage;

  DatabaseService({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _secureStorage = secureStorage;

  Future<void> init() async {
    // Register Adapters
    Hive.registerAdapter(PatientAdapter());
    Hive.registerAdapter(DiagnosticReportAdapter());
    Hive.registerAdapter(VisionTestResultAdapter());
    Hive.registerAdapter(EyeTwinMetricsAdapter());

    // Setup Encryption
    final encryptionKey = await _getOrCreateEncryptionKey();

    // Open Encrypted Boxes
    await Hive.openBox<Patient>(
      patientsBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await Hive.openBox<DiagnosticReport>(
      diagnosticReportsBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await Hive.openBox<VisionTestResult>(
      visionTestResultsBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await Hive.openBox<EyeTwinMetrics>(
      eyeTwinMetricsBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  Future<List<int>> _getOrCreateEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _encryptionKeyName);
    if (keyString == null) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64UrlEncode(key),
      );
      return key;
    }
    return base64Url.decode(keyString);
  }

  // --- Patients ---
  Box<Patient> get _patientsBox => Hive.box<Patient>(patientsBoxName);

  Future<void> savePatient(Patient patient) async {
    await _patientsBox.put(patient.id, patient);
  }

  Patient? getPatient(String id) {
    return _patientsBox.get(id);
  }

  List<Patient> getAllPatients() {
    return _patientsBox.values.toList();
  }

  // --- Diagnostic Reports ---
  Box<DiagnosticReport> get _reportsBox =>
      Hive.box<DiagnosticReport>(diagnosticReportsBoxName);

  Future<void> saveDiagnosticReport(DiagnosticReport report) async {
    await _reportsBox.put(report.id, report);
  }

  List<DiagnosticReport> getReportsForPatient(String patientId) {
    return _reportsBox.values.where((r) => r.patientId == patientId).toList();
  }

  // --- Vision Test Results ---
  Box<VisionTestResult> get _testsBox =>
      Hive.box<VisionTestResult>(visionTestResultsBoxName);

  Future<void> saveVisionTestResult(VisionTestResult result) async {
    await _testsBox.put(result.id, result);
  }

  List<VisionTestResult> getTestsForPatient(String patientId) {
    return _testsBox.values.where((t) => t.patientId == patientId).toList();
  }

  // --- Eye Twin Metrics ---
  Box<EyeTwinMetrics> get _metricsBox =>
      Hive.box<EyeTwinMetrics>(eyeTwinMetricsBoxName);

  Future<void> saveEyeTwinMetrics(EyeTwinMetrics metrics) async {
    await _metricsBox.put(metrics.patientId, metrics); // PatientId as key
  }

  EyeTwinMetrics? getEyeTwinMetrics(String patientId) {
    return _metricsBox.get(patientId);
  }
}
