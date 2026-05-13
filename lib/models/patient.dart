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

/// Expanded Patient model with FHIR-compatible fields and sqflite serialization.
class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String? email;
  final String? phone;
  final String? medicalRecordNumber;
  final String? diagnosis;
  final String? allergies;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final List<EyeExam> exams;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.email,
    this.phone,
    this.medicalRecordNumber,
    this.diagnosis,
    this.allergies,
    this.dateOfBirth,
    DateTime? createdAt,
    this.exams = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'email': email,
        'phone': phone,
        'medical_record_number': medicalRecordNumber,
        'diagnosis': diagnosis,
        'allergies': allergies,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  factory Patient.fromMap(Map<String, dynamic> m) => Patient(
        id: m['id'] as String,
        name: m['name'] as String,
        age: m['age'] as int,
        gender: m['gender'] as String,
        email: m['email'] as String?,
        phone: m['phone'] as String?,
        medicalRecordNumber: m['medical_record_number'] as String?,
        diagnosis: m['diagnosis'] as String?,
        allergies: m['allergies'] as String?,
        dateOfBirth: m['date_of_birth'] != null
            ? DateTime.parse(m['date_of_birth'] as String)
            : null,
        createdAt: m['created_at'] != null
            ? DateTime.parse(m['created_at'] as String)
            : DateTime.now(),
      );
}

class EyeExam {
  final int? id;
  final String patientId;
  final DateTime date;
  final String visualAcuityLeft;
  final String visualAcuityRight;
  final String intraocularPressureLeft;
  final String intraocularPressureRight;
  final String? colorVisionResult;
  final String notes;

  const EyeExam({
    this.id,
    this.patientId = '',
    required this.date,
    required this.visualAcuityLeft,
    required this.visualAcuityRight,
    required this.intraocularPressureLeft,
    required this.intraocularPressureRight,
    this.colorVisionResult,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'patient_id': patientId,
        'date': date.toIso8601String(),
        'visual_acuity_left': visualAcuityLeft,
        'visual_acuity_right': visualAcuityRight,
        'iop_left': intraocularPressureLeft,
        'iop_right': intraocularPressureRight,
        'color_vision_result': colorVisionResult,
        'notes': notes,
      };

  factory EyeExam.fromMap(Map<String, dynamic> m) => EyeExam(
        id: m['id'] as int?,
        patientId: m['patient_id'] as String? ?? '',
        date: DateTime.parse(m['date'] as String),
        visualAcuityLeft: m['visual_acuity_left'] as String,
        visualAcuityRight: m['visual_acuity_right'] as String,
        intraocularPressureLeft: m['iop_left'] as String,
        intraocularPressureRight: m['iop_right'] as String,
        colorVisionResult: m['color_vision_result'] as String?,
        notes: m['notes'] as String? ?? '',
      );
}
