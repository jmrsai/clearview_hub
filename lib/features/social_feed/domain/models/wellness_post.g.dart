// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WellnessPostImpl _$$WellnessPostImplFromJson(Map<String, dynamic> json) =>
    _$WellnessPostImpl(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      content: json['content'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      isAiGenerated: json['isAiGenerated'] as bool? ?? false,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$WellnessPostImplToJson(_$WellnessPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatar': instance.authorAvatar,
      'content': instance.content,
      'mediaUrl': instance.mediaUrl,
      'isAiGenerated': instance.isAiGenerated,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'timestamp': instance.timestamp.toIso8601String(),
      'tags': instance.tags,
    };
