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

/// Tracks medication dose compliance per patient.
class MedicationLog {
  final int? id;
  final String patientId;
  final String medicationName;
  final String dosage;       // e.g. "1 drop"
  final String frequency;    // e.g. "twice_daily"
  final DateTime scheduledAt;
  final DateTime? takenAt;   // null = missed
  final String status;       // 'taken' | 'missed' | 'pending'
  final String? notes;

  const MedicationLog({
    this.id,
    required this.patientId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.scheduledAt,
    this.takenAt,
    this.status = 'pending',
    this.notes,
  });

  bool get isTaken  => status == 'taken';
  bool get isMissed => status == 'missed';

  MedicationLog copyWith({String? status, DateTime? takenAt}) => MedicationLog(
        id: id,
        patientId: patientId,
        medicationName: medicationName,
        dosage: dosage,
        frequency: frequency,
        scheduledAt: scheduledAt,
        takenAt: takenAt ?? this.takenAt,
        status: status ?? this.status,
        notes: notes,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'patient_id': patientId,
        'medication_name': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'scheduled_at': scheduledAt.toIso8601String(),
        'taken_at': takenAt?.toIso8601String(),
        'status': status,
        'notes': notes,
      };

  factory MedicationLog.fromMap(Map<String, dynamic> m) => MedicationLog(
        id: m['id'] as int?,
        patientId: m['patient_id'] as String,
        medicationName: m['medication_name'] as String,
        dosage: m['dosage'] as String,
        frequency: m['frequency'] as String,
        scheduledAt: DateTime.parse(m['scheduled_at'] as String),
        takenAt: m['taken_at'] != null
            ? DateTime.parse(m['taken_at'] as String)
            : null,
        status: m['status'] as String? ?? 'pending',
        notes: m['notes'] as String?,
      );
}
