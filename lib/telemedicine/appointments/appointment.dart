import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

enum AppointmentStatus { scheduled, inProgress, completed, cancelled, missed }

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String patientId,
    required String doctorId,
    required DateTime scheduledTime,
    required Duration duration,
    required AppointmentStatus status,
    required String reasonForVisit,
    String? meetingRoomName,
    String? notes,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}
