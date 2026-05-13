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

/// Model for Doctor-specific data in Firestore.
class Doctor {
  final String uid;
  final String name;
  final String email;
  final String specialization;
  final String licenseNumber;
  final String clinicName;
  final bool isVerified;

  Doctor({
    required this.uid,
    required this.name,
    required this.email,
    required this.specialization,
    required this.licenseNumber,
    required this.clinicName,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'specialization': specialization,
    'license_number': licenseNumber,
    'clinic_name': clinicName,
    'is_verified': isVerified,
    'role': 'doctor',
  };

  factory Doctor.fromMap(Map<String, dynamic> m) => Doctor(
    uid: m['uid'] as String,
    name: m['name'] as String,
    email: m['email'] as String,
    specialization: m['specialization'] as String,
    licenseNumber: m['license_number'] as String,
    clinicName: m['clinic_name'] as String,
    isVerified: m['is_verified'] as bool? ?? false,
  );
}

/// Model for Administrator-specific data in Firestore.
class Administrator {
  final String uid;
  final String name;
  final String email;
  final List<String> permissions;
  final bool isSuperAdmin;

  Administrator({
    required this.uid,
    required this.name,
    required this.email,
    required this.permissions,
    this.isSuperAdmin = false,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'permissions': permissions,
    'is_super_admin': isSuperAdmin,
    'role': 'admin',
  };

  factory Administrator.fromMap(Map<String, dynamic> m) => Administrator(
    uid: m['uid'] as String,
    name: m['name'] as String,
    email: m['email'] as String,
    permissions: List<String>.from(m['permissions'] ?? []),
    isSuperAdmin: m['is_super_admin'] as bool? ?? false,
  );
}
