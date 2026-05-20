import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  sticker,
  wellness_tip,
  exercise_guide,
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderId,
    required String content,
    required MessageType type,
    required DateTime timestamp,
    @Default(false) bool isRead,
    @Default(false) bool isEdited,
    @Default(false) bool isForwarded,
    String? replyToId,
    @Default({}) Map<String, int> reactions, // emoji -> count
    String? mediaUrl,
    String? localPath,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class ChatGroup with _$ChatGroup {
  const factory ChatGroup({
    required String id,
    required String name,
    required String? description,
    required String? imageUrl,
    required List<String> memberIds,
    required List<String> adminIds,
    required String createdById,
    required DateTime createdAt,
    @Default(false) bool isChannel, // Telegram-style channel
    @Default(false) bool isEncrypted,
  }) = _ChatGroup;

  factory ChatGroup.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupFromJson(json);
}
