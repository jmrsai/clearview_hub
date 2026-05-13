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

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/patient.dart';
import '../../models/vision_test_result.dart';
import '../../models/fhir_models.dart';

/// FHIR R4 EHR service layer.
/// Converts local models to FHIR resources and syncs to a FHIR-compatible server.
class EhrService {
  EhrService._({
    String baseUrl = 'https://hapi.fhir.org/baseR4',
    String? authToken,
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _authToken = authToken,
        _client = client ?? http.Client();

  static final EhrService instance = EhrService._();

  final String _baseUrl;
  final String? _authToken;
  final http.Client _client;

  Map<String, String> get _headers => {
        'Content-Type': 'application/fhir+json',
        'Accept': 'application/fhir+json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // ── Sync Logic ──────────────────────────────────────────────────────────

  Future<bool> exportToFhir(VisionTestResult result) async {
    final observations = _toFhirObservations(result);
    try {
      for (final obs in observations) {
        final response = await _client.post(
          Uri.parse('$_baseUrl/Observation'),
          headers: _headers,
          body: jsonEncode(obs.toJson()),
        );
        if (response.statusCode != 200 && response.statusCode != 201) return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> syncPatient(Patient patient) async {
    final fhirPatient = _toFhirPatient(patient);
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/Patient/${patient.id}'),
        headers: _headers,
        body: jsonEncode(fhirPatient.toJson()),
      );
      return (response.statusCode == 200 || response.statusCode == 201) ? patient.id : null;
    } catch (_) {
      return null;
    }
  }

  // ── Converters ────────────────────────────────────────────────────────────

  FhirPatient _toFhirPatient(Patient p) {
    final nameParts = p.name.trim().split(' ');
    return FhirPatient(
      id: p.id,
      name: [
        FhirHumanName(
          family: nameParts.length > 1 ? nameParts.last : p.name,
          given: nameParts.length > 1 ? nameParts.sublist(0, nameParts.length - 1) : [p.name],
        ),
      ],
      gender: p.gender.toLowerCase() == 'male' ? 'male' : p.gender.toLowerCase() == 'female' ? 'female' : 'unknown',
      telecom: [
        if (p.email != null) FhirContactPoint(system: 'email', value: p.email!),
        if (p.phone != null) FhirContactPoint(system: 'phone', value: p.phone!),
      ],
    );
  }

  List<FhirObservation> _toFhirObservations(VisionTestResult result) {
    final subject = FhirReference(reference: 'Patient/${result.patientId}');
    final effectiveDateTime = result.performedAt.toIso8601String();
    final notes = result.notes;

    if (result.testType == 'snellen') {
      return [
        _createObs('snellen-${result.id}-L', EyeCareLoinc.visualAcuity, 'VA Left', result.acuityLeft, subject, effectiveDateTime),
        _createObs('snellen-${result.id}-R', EyeCareLoinc.visualAcuity, 'VA Right', result.acuityRight, subject, effectiveDateTime),
      ];
    } else if (result.testType == 'color_blindness') {
      return [
        _createObs('color-${result.id}', '79092-3', 'Color Vision (Ishihara)', 
          '${result.correctAnswers}/${result.totalQuestions} correct', subject, effectiveDateTime),
      ];
    } else if (result.testType == 'amsler') {
      return [
        _createObs('amsler-${result.id}', '79103-8', 'Amsler Grid Distortion', 
          (notes?.isEmpty ?? true) ? 'Negative' : 'Positive: $notes', subject, effectiveDateTime),
      ];
    } else if (result.testType == 'ai_screening') {
      return [
        _createObs('ai-${result.id}', '110461004', 'AI Eye Screening', notes ?? '', subject, effectiveDateTime, system: 'http://snomed.info/sct'),
      ];
    }
    return [];
  }

  FhirObservation _createObs(String id, String code, String display, String value, FhirReference sub, String date, {String system = EyeCareLoinc.system}) {
    return FhirObservation(
      id: id,
      code: FhirCodeableConcept(
        coding: [FhirCoding(system: system, code: code, display: display)],
        text: display,
      ),
      subject: sub,
      effectiveDateTime: date,
      valueString: value,
    );
  }

  void dispose() => _client.close();
}
