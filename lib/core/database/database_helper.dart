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

import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';
import '../../models/patient.dart';
import '../../models/vision_test_result.dart';
import '../../models/medication_log.dart';

/// Singleton sqflite database for ClearView Hub.
/// Tables: patients, eye_exams, vision_test_results, medication_logs, exercise_sessions
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'clearview_hub_encrypted.db';
  static const _dbVersion = 1;
  static const _storage = FlutterSecureStorage();
  static const _dbKeyName = 'database_encryption_key';

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<String> _getDatabasePassword() async {
    String? key = await _storage.read(key: _dbKeyName);
    if (key == null) {
      final random = Random.secure();
      final values = List<int>.generate(32, (i) => random.nextInt(256));
      key = base64UrlEncode(values);
      await _storage.write(key: _dbKeyName, value: key);
    }
    return key;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    final password = await _getDatabasePassword();
    return openDatabase(
      path,
      version: _dbVersion,
      password: password,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        medical_record_number TEXT,
        diagnosis TEXT,
        allergies TEXT,
        date_of_birth TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE eye_exams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT NOT NULL,
        date TEXT NOT NULL,
        visual_acuity_left TEXT NOT NULL,
        visual_acuity_right TEXT NOT NULL,
        iop_left TEXT NOT NULL,
        iop_right TEXT NOT NULL,
        color_vision_result TEXT,
        notes TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE vision_test_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT NOT NULL,
        test_type TEXT NOT NULL,
        performed_at TEXT NOT NULL,
        acuity_left TEXT,
        acuity_right TEXT,
        correct_answers INTEGER DEFAULT 0,
        total_questions INTEGER DEFAULT 0,
        distortion_map_json TEXT,
        sync_status TEXT DEFAULT 'pending',
        notes TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE medication_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT NOT NULL,
        medication_name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        scheduled_at TEXT NOT NULL,
        taken_at TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        notes TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE exercise_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT NOT NULL,
        exercise_type TEXT NOT NULL,
        duration_seconds INTEGER NOT NULL,
        performed_at TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE audit_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        action TEXT NOT NULL,
        resource TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        details TEXT,
        sync_status TEXT DEFAULT 'pending'
      )
    ''');
  }

  // ── Patients ──────────────────────────────────────────────────────────────

  Future<int> insertPatient(Patient p) async {
    final db = await database;
    await db.insert('patients', p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return 1;
  }

  Future<List<Patient>> getAllPatients() async {
    final db = await database;
    final rows = await db.query('patients', orderBy: 'created_at DESC');
    return rows.map(Patient.fromMap).toList();
  }

  Future<Patient?> getPatient(String id) async {
    final db = await database;
    final rows = await db.query('patients', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Patient.fromMap(rows.first);
  }

  Future<int> updatePatient(Patient p) async {
    final db = await database;
    return db.update('patients', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  Future<int> deletePatient(String id) async {
    final db = await database;
    return db.delete('patients', where: 'id = ?', whereArgs: [id]);
  }

  // ── Eye Exams ─────────────────────────────────────────────────────────────

  Future<int> insertExam(EyeExam exam) async {
    final db = await database;
    return db.insert('eye_exams', exam.toMap());
  }

  Future<List<EyeExam>> getExamsForPatient(String patientId) async {
    final db = await database;
    final rows = await db.query('eye_exams',
        where: 'patient_id = ?',
        whereArgs: [patientId],
        orderBy: 'date DESC');
    return rows.map(EyeExam.fromMap).toList();
  }

  // ── Vision Test Results ───────────────────────────────────────────────────

  Future<int> insertVisionTestResult(VisionTestResult r) async {
    final db = await database;
    return db.insert('vision_test_results', r.toMap());
  }

  Future<List<VisionTestResult>> getVisionTestsForPatient(String patientId) async {
    final db = await database;
    final rows = await db.query('vision_test_results',
        where: 'patient_id = ?',
        whereArgs: [patientId],
        orderBy: 'performed_at DESC');
    return rows.map(VisionTestResult.fromMap).toList();
  }

  Future<List<VisionTestResult>> getVisionTestsByType(
      String patientId, String testType) async {
    final db = await database;
    final rows = await db.query('vision_test_results',
        where: 'patient_id = ? AND test_type = ?',
        whereArgs: [patientId, testType],
        orderBy: 'performed_at ASC');
    return rows.map(VisionTestResult.fromMap).toList();
  }

  Future<List<VisionTestResult>> getPendingSyncTests() async {
    final db = await database;
    final rows = await db.query(
      'vision_test_results',
      where: 'sync_status = ?',
      whereArgs: ['pending'],
    );
    return rows.map(VisionTestResult.fromMap).toList();
  }

  Future<void> updateSyncStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'vision_test_results',
      {'sync_status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ── Medication Logs ───────────────────────────────────────────────────────

  Future<int> insertMedicationLog(MedicationLog log) async {
    final db = await database;
    return db.insert('medication_logs', log.toMap());
  }

  Future<List<MedicationLog>> getMedicationLogsForPatient(String patientId) async {
    final db = await database;
    final rows = await db.query('medication_logs',
        where: 'patient_id = ?',
        whereArgs: [patientId],
        orderBy: 'scheduled_at DESC');
    return rows.map(MedicationLog.fromMap).toList();
  }

  Future<int> updateMedicationLog(MedicationLog log) async {
    final db = await database;
    return db.update('medication_logs', log.toMap(),
        where: 'id = ?', whereArgs: [log.id]);
  }

  Future<Map<DateTime, int>> getMedicationComplianceMap(String patientId) async {
    final db = await database;
    final rows = await db.query('medication_logs',
        where: "patient_id = ? AND status = 'taken'",
        whereArgs: [patientId]);
    final map = <DateTime, int>{};
    for (final row in rows) {
      final day = DateTime.parse(row['scheduled_at'] as String);
      final key = DateTime(day.year, day.month, day.day);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  // ── Eye Exercise Sessions ──────────────────────────────────────────────────
  
  Future<int> insertEyeExerciseSession(Map<String, dynamic> session) async {
    final db = await database;
    return db.insert('exercise_sessions', session);
  }

  Future<List<Map<String, dynamic>>> getEyeExerciseSessionsForPatient(String patientId) async {
    final db = await database;
    return db.query('exercise_sessions',
        where: 'patient_id = ?',
        whereArgs: [patientId],
        orderBy: 'performed_at DESC');
  }

  // ── Audit Logs ─────────────────────────────────────────────────────────────

  Future<int> insertAuditLog(Map<String, dynamic> log) async {
    final db = await database;
    return db.insert('audit_logs', log);
  }

  Future<void> close() async => _db?.close();
}
