// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicBusinessImpl _$$ClinicBusinessImplFromJson(Map<String, dynamic> json) =>
    _$ClinicBusinessImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      businessName: json['businessName'] as String,
      businessType: json['businessType'] as String,
      description: json['description'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      address: json['address'] as Map<String, dynamic>?,
      verificationStatus: json['verificationStatus'] as String? ?? 'pending',
      subscriptionTier: json['subscriptionTier'] as String? ?? 'free',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClinicBusinessImplToJson(
        _$ClinicBusinessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'businessName': instance.businessName,
      'businessType': instance.businessType,
      'description': instance.description,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'websiteUrl': instance.websiteUrl,
      'address': instance.address,
      'verificationStatus': instance.verificationStatus,
      'subscriptionTier': instance.subscriptionTier,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
