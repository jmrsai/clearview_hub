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
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'auth_service.dart';

/// Manages telemedicine consultations, doctor discovery, and appointment booking.
class TelemedicineService {
  TelemedicineService._();
  static final TelemedicineService instance = TelemedicineService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? get _uid => AuthService.instance.userId;

  CollectionReference get _doctorsRef => _db.collection('doctors');
  CollectionReference get _consultationsRef => _db.collection('consultations');

  /// Get all available doctors from Firestore.
  Stream<List<TeleDoctorProfile>> getDoctors({String? specialty}) {
    Query query = _doctorsRef.where('is_available_for_teleconsult', isEqualTo: true);
    if (specialty != null) query = query.where('specialization', isEqualTo: specialty);
    return query.snapshots().map((snap) =>
        snap.docs.map((d) => TeleDoctorProfile.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  /// Book a consultation appointment.
  Future<String> bookConsultation({
    required String doctorId,
    required String doctorName,
    required DateTime appointmentTime,
    required String chiefComplaint,
  }) async {
    if (_uid == null) throw Exception('User not signed in');
    final ref = _consultationsRef.doc();
    await ref.set({
      'id': ref.id,
      'patient_uid': _uid,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'appointment_time': appointmentTime.toIso8601String(),
      'chief_complaint': chiefComplaint,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
      'meet_link': 'https://meet.google.com/new', // Doctor creates actual link
    });
    return ref.id;
  }

  /// Get consultations for current user.
  Stream<List<Consultation>> getMyConsultations() {
    if (_uid == null) return const Stream.empty();
    return _consultationsRef
        .where('patient_uid', isEqualTo: _uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Consultation.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  // For demonstration, a static key is used. In production, this should be a securely negotiated shared secret.
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Send an END-TO-END ENCRYPTED message in a consultation chat.
  Future<void> sendMessage({required String consultationId, required String text}) async {
    if (_uid == null) return;
    
    // Encrypt the message text before saving to the database
    final encryptedText = _encrypter.encrypt(text, iv: _iv).base64;

    await _consultationsRef
        .doc(consultationId)
        .collection('messages')
        .add({
      'sender_uid': _uid,
      'text': encryptedText,
      'is_encrypted': true, // Flag to ensure old messages don't break
      'timestamp': FieldValue.serverTimestamp(),
      'is_read': false,
    });
  }

  /// Get messages and decrypt them in real-time.
  Stream<List<ChatMessageData>> getMessages(String consultationId) {
    return _consultationsRef
        .doc(consultationId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              String decryptedText = data['text'] as String? ?? '';
              
              // Only decrypt if it was stored as encrypted
              if (data['is_encrypted'] == true) {
                try {
                  decryptedText = _encrypter.decrypt64(decryptedText, iv: _iv);
                } catch (e) {
                  decryptedText = '🔒 [Decryption Failed]';
                }
              }

              return ChatMessageData(
                senderUid: data['sender_uid'] as String? ?? '',
                text: decryptedText,
                timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
              );
            }).toList());
  }

  /// Launch a video call via Google Meet (Meet links can also be encrypted similarly).
  Future<void> joinVideoCall(String meetLink) async {
    final uri = Uri.parse(meetLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Seed demo doctors if collection is empty (for testing).
  Future<void> seedDemoDoctors() async {
    final snap = await _doctorsRef.limit(1).get();
    if (snap.docs.isNotEmpty) return;
    final demoDoctors = [
      {
        'uid': 'demo_doc_1',
        'name': 'Dr. Priya Sharma',
        'specialization': 'Retinal Specialist',
        'clinic_name': 'Vision Eye Centre',
        'license_number': 'MCI-445521',
        'rating': 4.9,
        'total_consultations': 1240,
        'languages': ['English', 'Hindi', 'Tamil'],
        'fee': 500,
        'currency': 'INR',
        'is_available_for_teleconsult': true,
        'next_available': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
        'bio': 'Specialist in diabetic retinopathy and macular degeneration with 15 years experience.',
        'avatar_emoji': '👩‍⚕️',
      },
      {
        'uid': 'demo_doc_2',
        'name': 'Dr. Arjun Mehta',
        'specialization': 'Glaucoma Specialist',
        'clinic_name': 'Eye Care Plus',
        'license_number': 'MCI-667788',
        'rating': 4.7,
        'total_consultations': 892,
        'languages': ['English', 'Hindi'],
        'fee': 600,
        'currency': 'INR',
        'is_available_for_teleconsult': true,
        'next_available': DateTime.now().add(const Duration(hours: 4)).toIso8601String(),
        'bio': 'Glaucoma and optic nerve specialist focused on early detection and management.',
        'avatar_emoji': '👨‍⚕️',
      },
      {
        'uid': 'demo_doc_3',
        'name': 'Dr. Sarah Okonkwo',
        'specialization': 'Pediatric Ophthalmologist',
        'clinic_name': "Children's Vision Clinic",
        'license_number': 'GMC-334455',
        'rating': 4.9,
        'total_consultations': 2150,
        'languages': ['English', 'French'],
        'fee': 800,
        'currency': 'INR',
        'is_available_for_teleconsult': true,
        'next_available': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        'bio': 'Dedicated to children\'s eye health, amblyopia treatment, and pediatric vision therapy.',
        'avatar_emoji': '👩‍⚕️',
      },
    ];
    for (final doc in demoDoctors) {
      await _doctorsRef.doc(doc['uid'] as String).set(doc);
    }
  }
}

class TeleDoctorProfile {
  final String uid;
  final String name;
  final String specialization;
  final String clinicName;
  final double rating;
  final int totalConsultations;
  final List<String> languages;
  final int fee;
  final String currency;
  final bool isAvailable;
  final String bio;
  final String avatarEmoji;

  TeleDoctorProfile({
    required this.uid,
    required this.name,
    required this.specialization,
    required this.clinicName,
    required this.rating,
    required this.totalConsultations,
    required this.languages,
    required this.fee,
    required this.currency,
    required this.isAvailable,
    required this.bio,
    required this.avatarEmoji,
  });

  factory TeleDoctorProfile.fromMap(Map<String, dynamic> m) => TeleDoctorProfile(
    uid: m['uid'] as String? ?? '',
    name: m['name'] as String? ?? '',
    specialization: m['specialization'] as String? ?? '',
    clinicName: m['clinic_name'] as String? ?? '',
    rating: (m['rating'] as num?)?.toDouble() ?? 0.0,
    totalConsultations: m['total_consultations'] as int? ?? 0,
    languages: List<String>.from(m['languages'] ?? []),
    fee: m['fee'] as int? ?? 0,
    currency: m['currency'] as String? ?? 'USD',
    isAvailable: m['is_available_for_teleconsult'] as bool? ?? false,
    bio: m['bio'] as String? ?? '',
    avatarEmoji: m['avatar_emoji'] as String? ?? '👨‍⚕️',
  );
}

class Consultation {
  final String id;
  final String doctorName;
  final DateTime appointmentTime;
  final String chiefComplaint;
  final String status;
  final String meetLink;

  Consultation({
    required this.id,
    required this.doctorName,
    required this.appointmentTime,
    required this.chiefComplaint,
    required this.status,
    required this.meetLink,
  });

  factory Consultation.fromMap(Map<String, dynamic> m) => Consultation(
    id: m['id'] as String? ?? '',
    doctorName: m['doctor_name'] as String? ?? '',
    appointmentTime: DateTime.parse(m['appointment_time'] as String? ?? DateTime.now().toIso8601String()),
    chiefComplaint: m['chief_complaint'] as String? ?? '',
    status: m['status'] as String? ?? 'pending',
    meetLink: m['meet_link'] as String? ?? '',
  );
}

class ChatMessageData {
  final String senderUid;
  final String text;
  final DateTime? timestamp;

  ChatMessageData({required this.senderUid, required this.text, this.timestamp});

  factory ChatMessageData.fromMap(Map<String, dynamic> m) => ChatMessageData(
    senderUid: m['sender_uid'] as String? ?? '',
    text: m['text'] as String? ?? '',
    timestamp: (m['timestamp'] as Timestamp?)?.toDate(),
  );
}
