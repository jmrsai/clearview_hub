import '../entities/doctor.dart';
import '../entities/appointment.dart';

abstract class TelemedicineRepository {
  Future<List<Doctor>> getDoctors({String? specialization});
  Future<List<Appointment>> getMyAppointments();
  Future<Appointment> bookAppointment({
    required String doctorId,
    required DateTime date,
    String? notes,
  });
  Future<void> cancelAppointment(String appointmentId);
}
