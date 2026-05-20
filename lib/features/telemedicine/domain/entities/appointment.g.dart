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
      doctorName: json['doctorName'] as String?,
      doctorAvatarUrl: json['doctorAvatarUrl'] as String?,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      status: json['status'] as String? ?? 'scheduled',
      meetingLink: json['meetingLink'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'doctorAvatarUrl': instance.doctorAvatarUrl,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'status': instance.status,
      'meetingLink': instance.meetingLink,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
