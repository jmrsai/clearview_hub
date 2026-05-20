// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicationReminderImpl _$$MedicationReminderImplFromJson(
        Map<String, dynamic> json) =>
    _$MedicationReminderImpl(
      id: json['id'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      time: DateTime.parse(json['time'] as String),
      isActive: json['isActive'] as bool? ?? true,
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MedicationReminderImplToJson(
        _$MedicationReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationName': instance.medicationName,
      'dosage': instance.dosage,
      'time': instance.time.toIso8601String(),
      'isActive': instance.isActive,
      'history': instance.history.map((e) => e.toIso8601String()).toList(),
    };
