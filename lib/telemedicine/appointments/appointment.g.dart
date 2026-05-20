// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
      reasonForVisit: json['reasonForVisit'] as String,
      meetingRoomName: json['meetingRoomName'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'reasonForVisit': instance.reasonForVisit,
      'meetingRoomName': instance.meetingRoomName,
      'notes': instance.notes,
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.inProgress: 'inProgress',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.missed: 'missed',
};
