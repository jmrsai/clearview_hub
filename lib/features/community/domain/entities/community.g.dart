// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityImpl _$$CommunityImplFromJson(Map<String, dynamic> json) =>
    _$CommunityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      category: json['category'] as String? ?? 'general',
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommunityImplToJson(_$CommunityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'bannerUrl': instance.bannerUrl,
      'category': instance.category,
      'memberCount': instance.memberCount,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
