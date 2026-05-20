// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      isForwarded: json['isForwarded'] as bool? ?? false,
      replyToId: json['replyToId'] as String?,
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      mediaUrl: json['mediaUrl'] as String?,
      localPath: json['localPath'] as String?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'isEdited': instance.isEdited,
      'isForwarded': instance.isForwarded,
      'replyToId': instance.replyToId,
      'reactions': instance.reactions,
      'mediaUrl': instance.mediaUrl,
      'localPath': instance.localPath,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
  MessageType.file: 'file',
  MessageType.sticker: 'sticker',
  MessageType.wellness_tip: 'wellness_tip',
  MessageType.exercise_guide: 'exercise_guide',
};

_$ChatGroupImpl _$$ChatGroupImplFromJson(Map<String, dynamic> json) =>
    _$ChatGroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      adminIds:
          (json['adminIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdById: json['createdById'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isChannel: json['isChannel'] as bool? ?? false,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatGroupImplToJson(_$ChatGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'memberIds': instance.memberIds,
      'adminIds': instance.adminIds,
      'createdById': instance.createdById,
      'createdAt': instance.createdAt.toIso8601String(),
      'isChannel': instance.isChannel,
      'isEncrypted': instance.isEncrypted,
    };
