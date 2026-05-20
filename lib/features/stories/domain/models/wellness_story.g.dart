// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WellnessStoryImpl _$$WellnessStoryImplFromJson(Map<String, dynamic> json) =>
    _$WellnessStoryImpl(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      mediaUrl: json['mediaUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$$WellnessStoryImplToJson(_$WellnessStoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatar': instance.authorAvatar,
      'mediaUrl': instance.mediaUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'isViewed': instance.isViewed,
      'caption': instance.caption,
    };
