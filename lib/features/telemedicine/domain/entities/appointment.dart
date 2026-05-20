import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String patientId,
    required String doctorId,
    String? doctorName,
    String? doctorAvatarUrl,
    required DateTime appointmentDate,
    @Default('scheduled') String status,
    String? meetingLink,
    String? notes,
    DateTime? createdAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
}
