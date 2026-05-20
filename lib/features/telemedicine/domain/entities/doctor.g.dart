// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DoctorImpl _$$DoctorImplFromJson(Map<String, dynamic> json) => _$DoctorImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      hospitalAffiliation: json['hospitalAffiliation'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableHours: (json['availableHours'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DoctorImplToJson(_$DoctorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'specialization': instance.specialization,
      'hospitalAffiliation': instance.hospitalAffiliation,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'rating': instance.rating,
      'consultationFee': instance.consultationFee,
      'isAvailable': instance.isAvailable,
      'availableHours': instance.availableHours,
    };
