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

/// FHIR R4-compatible JSON models for EHR interoperability.
library;

// ── Patient ──────────────────────────────────────────────────────────────────

class FhirPatient {
  final String resourceType = 'Patient';
  final String id;
  final List<FhirHumanName> name;
  final String gender; // 'male' | 'female' | 'other' | 'unknown'
  final String? birthDate; // ISO 8601 "YYYY-MM-DD"
  final List<FhirContactPoint>? telecom;

  const FhirPatient({
    required this.id,
    required this.name,
    required this.gender,
    this.birthDate,
    this.telecom,
  });

  Map<String, dynamic> toJson() => {
        'resourceType': resourceType,
        'id': id,
        'name': name.map((n) => n.toJson()).toList(),
        'gender': gender,
        if (birthDate != null) 'birthDate': birthDate,
        if (telecom != null) 'telecom': telecom!.map((t) => t.toJson()).toList(),
      };

  factory FhirPatient.fromJson(Map<String, dynamic> j) => FhirPatient(
        id: j['id'] as String,
        name: (j['name'] as List<dynamic>)
            .map((n) => FhirHumanName.fromJson(n as Map<String, dynamic>))
            .toList(),
        gender: j['gender'] as String? ?? 'unknown',
        birthDate: j['birthDate'] as String?,
      );
}

class FhirHumanName {
  final String use; // 'official' | 'usual' | 'nickname'
  final String family;
  final List<String> given;

  const FhirHumanName({
    this.use = 'official',
    required this.family,
    required this.given,
  });

  String get displayName => '${given.join(' ')} $family';

  Map<String, dynamic> toJson() =>
      {'use': use, 'family': family, 'given': given};

  factory FhirHumanName.fromJson(Map<String, dynamic> j) => FhirHumanName(
        use: j['use'] as String? ?? 'official',
        family: j['family'] as String,
        given: (j['given'] as List<dynamic>).cast<String>(),
      );
}

class FhirContactPoint {
  final String system; // 'phone' | 'email'
  final String value;

  const FhirContactPoint({required this.system, required this.value});

  Map<String, dynamic> toJson() => {'system': system, 'value': value};

  factory FhirContactPoint.fromJson(Map<String, dynamic> j) =>
      FhirContactPoint(system: j['system'] as String, value: j['value'] as String);
}

// ── Observation ───────────────────────────────────────────────────────────────

class FhirObservation {
  final String resourceType = 'Observation';
  final String id;
  final String status; // 'final' | 'preliminary'
  final FhirCodeableConcept code;
  final FhirReference subject;
  final String effectiveDateTime;
  final FhirQuantity? valueQuantity;
  final String? valueString;
  final List<FhirObservationComponent>? component;

  const FhirObservation({
    required this.id,
    this.status = 'final',
    required this.code,
    required this.subject,
    required this.effectiveDateTime,
    this.valueQuantity,
    this.valueString,
    this.component,
  });

  Map<String, dynamic> toJson() => {
        'resourceType': resourceType,
        'id': id,
        'status': status,
        'code': code.toJson(),
        'subject': subject.toJson(),
        'effectiveDateTime': effectiveDateTime,
        if (valueQuantity != null) 'valueQuantity': valueQuantity!.toJson(),
        if (valueString != null) 'valueString': valueString,
        if (component != null)
          'component': component!.map((c) => c.toJson()).toList(),
      };
}

class FhirCodeableConcept {
  final List<FhirCoding> coding;
  final String? text;

  const FhirCodeableConcept({required this.coding, this.text});

  Map<String, dynamic> toJson() => {
        'coding': coding.map((c) => c.toJson()).toList(),
        if (text != null) 'text': text,
      };
}

class FhirCoding {
  final String system;
  final String code;
  final String? display;

  const FhirCoding({required this.system, required this.code, this.display});

  Map<String, dynamic> toJson() => {
        'system': system,
        'code': code,
        if (display != null) 'display': display,
      };
}

class FhirReference {
  final String reference; // e.g. "Patient/P-1024"

  const FhirReference({required this.reference});

  Map<String, dynamic> toJson() => {'reference': reference};
}

class FhirQuantity {
  final double value;
  final String unit;
  final String? system;
  final String? code;

  const FhirQuantity({required this.value, required this.unit, this.system, this.code});

  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': unit,
        if (system != null) 'system': system,
        if (code != null) 'code': code,
      };
}

class FhirObservationComponent {
  final FhirCodeableConcept code;
  final String? valueString;
  final FhirQuantity? valueQuantity;

  const FhirObservationComponent({required this.code, this.valueString, this.valueQuantity});

  Map<String, dynamic> toJson() => {
        'code': code.toJson(),
        if (valueString != null) 'valueString': valueString,
        if (valueQuantity != null) 'valueQuantity': valueQuantity!.toJson(),
      };
}

// ── Common LOINC codes for eye care ──────────────────────────────────────────
class EyeCareLoinc {
  static const String visualAcuity = '79880-1';
  static const String intraocularPressure = '28842-4';
  static const String colorVisionTest = '79092-3';
  static const String system = 'http://loinc.org';
}
