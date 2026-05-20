// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityPostImpl _$$CommunityPostImplFromJson(Map<String, dynamic> json) =>
    _$CommunityPostImpl(
      id: json['id'] as String,
      communityId: json['communityId'] as String,
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String?,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
      comment_count: (json['comment_count'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isUpvotedByMe: json['isUpvotedByMe'] as bool? ?? false,
      isDownvotedByMe: json['isDownvotedByMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommunityPostImplToJson(_$CommunityPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'communityId': instance.communityId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'title': instance.title,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'isAnonymous': instance.isAnonymous,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'comment_count': instance.comment_count,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isUpvotedByMe': instance.isUpvotedByMe,
      'isDownvotedByMe': instance.isDownvotedByMe,
    };
