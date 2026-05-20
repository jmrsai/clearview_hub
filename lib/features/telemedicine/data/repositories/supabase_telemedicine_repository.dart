import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/telemedicine_repository.dart';

class SupabaseTelemedicineRepository implements TelemedicineRepository {
  final SupabaseClient _client;

  SupabaseTelemedicineRepository(this._client);

  @override
  Future<List<Doctor>> getDoctors({String? specialization}) async {
    var query = _client.from('doctors').select('''
      *,
      profile:profiles(full_name, avatar_url)
    ''');

    if (specialization != null) {
      query = query.eq('specialization', specialization);
    }

    final response = await query.order('rating', ascending: false);
    
    return (response as List).map((json) {
      return Doctor.fromJson(json).copyWith(
        name: json['profile']['full_name'],
        avatarUrl: json['profile']['avatar_url'],
      );
    }).toList();
  }

  @override
  Future<List<Appointment>> getMyAppointments() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthorized');

    final response = await _client.from('appointments').select('''
      *,
      doctor:doctors(
        profile:profiles(full_name, avatar_url)
      )
    ''').eq('patient_id', user.id).order('appointment_date');

    return (response as List).map((json) {
      return Appointment.fromJson(json).copyWith(
        doctorName: json['doctor']['profile']['full_name'],
        doctorAvatarUrl: json['doctor']['profile']['avatar_url'],
      );
    }).toList();
  }

  @override
  Future<Appointment> bookAppointment({
    required String doctorId,
    required DateTime date,
    String? notes,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthorized');

    final response = await _client.from('appointments').insert({
      'patient_id': user.id,
      'doctor_id': doctorId,
      'appointment_date': date.toIso8601String(),
      'notes': notes,
    }).select().single();

    return Appointment.fromJson(response);
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await _client.from('appointments').update({'status': 'cancelled'}).eq('id', appointmentId);
  }
}
