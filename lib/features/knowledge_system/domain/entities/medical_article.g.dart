// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicalArticleImpl _$$MedicalArticleImplFromJson(Map<String, dynamic> json) =>
    _$MedicalArticleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      content: json['content'] as String,
      summary: json['summary'] as String?,
      authorId: json['authorId'] as String?,
      sourceOrganization: json['sourceOrganization'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      category: json['category'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isVerified: json['isVerified'] as bool? ?? true,
      languageCode: json['languageCode'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$MedicalArticleImplToJson(
        _$MedicalArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'content': instance.content,
      'summary': instance.summary,
      'authorId': instance.authorId,
      'sourceOrganization': instance.sourceOrganization,
      'sourceUrl': instance.sourceUrl,
      'category': instance.category,
      'tags': instance.tags,
      'isVerified': instance.isVerified,
      'languageCode': instance.languageCode,
      'viewCount': instance.viewCount,
      'publishedAt': instance.publishedAt?.toIso8601String(),
    };
