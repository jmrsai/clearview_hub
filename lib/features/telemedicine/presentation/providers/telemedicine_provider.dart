import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/telemedicine_repository.dart';
import '../../data/repositories/supabase_telemedicine_repository.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/entities/appointment.dart';

final telemedicineRepositoryProvider = Provider<TelemedicineRepository>((ref) {
  return SupabaseTelemedicineRepository(Supabase.instance.client);
});

final doctorsProvider = FutureProvider.family<List<Doctor>, String?>((ref, specialization) async {
  return ref.watch(telemedicineRepositoryProvider).getDoctors(specialization: specialization);
});

final myAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  return ref.watch(telemedicineRepositoryProvider).getMyAppointments();
});

class TelemedicineNotifier extends StateNotifier<AsyncValue<void>> {
  final TelemedicineRepository _repository;

  TelemedicineNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> bookAppointment({
    required String doctorId,
    required DateTime date,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.bookAppointment(doctorId: doctorId, date: date, notes: notes);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final telemedicineControllerProvider = StateNotifierProvider<TelemedicineNotifier, AsyncValue<void>>((ref) {
  return TelemedicineNotifier(ref.watch(telemedicineRepositoryProvider));
});
