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

/// Stores the result of a vision screening test session.
class VisionTestResult {
  final int? id;
  final String patientId;
  final String testType; // 'snellen' | 'amsler' | 'color_blindness'
  final DateTime performedAt;
  final String acuityLeft;  // e.g. "20/20"
  final String acuityRight; // e.g. "20/25"
  final int correctAnswers;
  final int totalQuestions;
  final String? distortionMapJson; // JSON blob for Amsler Grid
  final String? notes;

  const VisionTestResult({
    this.id,
    required this.patientId,
    required this.testType,
    required this.performedAt,
    this.acuityLeft = '',
    this.acuityRight = '',
    this.correctAnswers = 0,
    this.totalQuestions = 0,
    this.distortionMapJson,
    this.notes,
  });

  double get scorePercent =>
      totalQuestions == 0 ? 0 : correctAnswers / totalQuestions * 100;

  Map<String, dynamic> toMap() => {
        'id': id,
        'patient_id': patientId,
        'test_type': testType,
        'performed_at': performedAt.toIso8601String(),
        'acuity_left': acuityLeft,
        'acuity_right': acuityRight,
        'correct_answers': correctAnswers,
        'total_questions': totalQuestions,
        'distortion_map_json': distortionMapJson,
        'notes': notes,
      };

  factory VisionTestResult.fromMap(Map<String, dynamic> m) => VisionTestResult(
        id: m['id'] as int?,
        patientId: m['patient_id'] as String,
        testType: m['test_type'] as String,
        performedAt: DateTime.parse(m['performed_at'] as String),
        acuityLeft: m['acuity_left'] as String? ?? '',
        acuityRight: m['acuity_right'] as String? ?? '',
        correctAnswers: m['correct_answers'] as int? ?? 0,
        totalQuestions: m['total_questions'] as int? ?? 0,
        distortionMapJson: m['distortion_map_json'] as String?,
        notes: m['notes'] as String?,
      );
}
