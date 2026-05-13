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

/// A utility script to initialize the first document in Firestore for testing.
/// Run this within the app or as a separate script if needed.
class FirestoreInitializer {
  static Future<void> setupFirstDocument(String userId) async {
    final firestore = FirebaseFirestore.instance;

    // 1. Create the user document
    await firestore.collection('users').doc(userId).set({
      'name': 'Dr. Medical Professional',
      'email': 'doctor@example.com',
      'role': 'ophthalmologist',
      'created_at': FieldValue.serverTimestamp(),
    });

    // 2. Create the first patient sub-collection document
    await firestore.collection('users').doc(userId).collection('patients').doc('demo_patient_001').set({
      'name': 'John Doe',
      'age': 45,
      'gender': 'Male',
      'medical_record_number': 'MRN-12345',
      'diagnosis': 'Mild Myopia',
      'created_at': FieldValue.serverTimestamp(),
    });

    dev.log('✅ First document and collection structure initialized!', name: 'FirestoreInitializer');
  }
}
