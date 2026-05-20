// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_sickness_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MotionSicknessLogImpl _$$MotionSicknessLogImplFromJson(
        Map<String, dynamic> json) =>
    _$MotionSicknessLogImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      nauseaLevel: (json['nauseaLevel'] as num?)?.toDouble() ?? 0.0,
      dizzinessLevel: (json['dizzinessLevel'] as num?)?.toDouble() ?? 0.0,
      eyeStrainLevel: (json['eyeStrainLevel'] as num?)?.toDouble() ?? 0.0,
      headacheLevel: (json['headacheLevel'] as num?)?.toDouble() ?? 0.0,
      vomitingTendency: json['vomitingTendency'] as bool? ?? false,
      triggers: (json['triggers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$MotionSicknessLogImplToJson(
        _$MotionSicknessLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'nauseaLevel': instance.nauseaLevel,
      'dizzinessLevel': instance.dizzinessLevel,
      'eyeStrainLevel': instance.eyeStrainLevel,
      'headacheLevel': instance.headacheLevel,
      'vomitingTendency': instance.vomitingTendency,
      'triggers': instance.triggers,
      'notes': instance.notes,
    };
