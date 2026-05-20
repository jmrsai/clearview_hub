// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  bool get isForwarded => throw _privateConstructorUsedError;
  String? get replyToId => throw _privateConstructorUsedError;
  Map<String, int> get reactions =>
      throw _privateConstructorUsedError; // emoji -> count
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String content,
      MessageType type,
      DateTime timestamp,
      bool isRead,
      bool isEdited,
      bool isForwarded,
      String? replyToId,
      Map<String, int> reactions,
      String? mediaUrl,
      String? localPath});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? content = null,
    Object? type = null,
    Object? timestamp = null,
    Object? isRead = null,
    Object? isEdited = null,
    Object? isForwarded = null,
    Object? replyToId = freezed,
    Object? reactions = null,
    Object? mediaUrl = freezed,
    Object? localPath = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isForwarded: null == isForwarded
          ? _value.isForwarded
          : isForwarded // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToId: freezed == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String?,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String content,
      MessageType type,
      DateTime timestamp,
      bool isRead,
      bool isEdited,
      bool isForwarded,
      String? replyToId,
      Map<String, int> reactions,
      String? mediaUrl,
      String? localPath});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? content = null,
    Object? type = null,
    Object? timestamp = null,
    Object? isRead = null,
    Object? isEdited = null,
    Object? isForwarded = null,
    Object? replyToId = freezed,
    Object? reactions = null,
    Object? mediaUrl = freezed,
    Object? localPath = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isForwarded: null == isForwarded
          ? _value.isForwarded
          : isForwarded // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToId: freezed == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String?,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.senderId,
      required this.content,
      required this.type,
      required this.timestamp,
      this.isRead = false,
      this.isEdited = false,
      this.isForwarded = false,
      this.replyToId,
      final Map<String, int> reactions = const {},
      this.mediaUrl,
      this.localPath})
      : _reactions = reactions;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String content;
  @override
  final MessageType type;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  @JsonKey()
  final bool isForwarded;
  @override
  final String? replyToId;
  final Map<String, int> _reactions;
  @override
  @JsonKey()
  Map<String, int> get reactions {
    if (_reactions is EqualUnmodifiableMapView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reactions);
  }

// emoji -> count
  @override
  final String? mediaUrl;
  @override
  final String? localPath;

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, content: $content, type: $type, timestamp: $timestamp, isRead: $isRead, isEdited: $isEdited, isForwarded: $isForwarded, replyToId: $replyToId, reactions: $reactions, mediaUrl: $mediaUrl, localPath: $localPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.isForwarded, isForwarded) ||
                other.isForwarded == isForwarded) &&
            (identical(other.replyToId, replyToId) ||
                other.replyToId == replyToId) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderId,
      content,
      type,
      timestamp,
      isRead,
      isEdited,
      isForwarded,
      replyToId,
      const DeepCollectionEquality().hash(_reactions),
      mediaUrl,
      localPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String senderId,
      required final String content,
      required final MessageType type,
      required final DateTime timestamp,
      final bool isRead,
      final bool isEdited,
      final bool isForwarded,
      final String? replyToId,
      final Map<String, int> reactions,
      final String? mediaUrl,
      final String? localPath}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get content;
  @override
  MessageType get type;
  @override
  DateTime get timestamp;
  @override
  bool get isRead;
  @override
  bool get isEdited;
  @override
  bool get isForwarded;
  @override
  String? get replyToId;
  @override
  Map<String, int> get reactions;
  @override // emoji -> count
  String? get mediaUrl;
  @override
  String? get localPath;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatGroup _$ChatGroupFromJson(Map<String, dynamic> json) {
  return _ChatGroup.fromJson(json);
}

/// @nodoc
mixin _$ChatGroup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get memberIds => throw _privateConstructorUsedError;
  List<String> get adminIds => throw _privateConstructorUsedError;
  String get createdById => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isChannel =>
      throw _privateConstructorUsedError; // Telegram-style channel
  bool get isEncrypted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatGroupCopyWith<ChatGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatGroupCopyWith<$Res> {
  factory $ChatGroupCopyWith(ChatGroup value, $Res Function(ChatGroup) then) =
      _$ChatGroupCopyWithImpl<$Res, ChatGroup>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? imageUrl,
      List<String> memberIds,
      List<String> adminIds,
      String createdById,
      DateTime createdAt,
      bool isChannel,
      bool isEncrypted});
}

/// @nodoc
class _$ChatGroupCopyWithImpl<$Res, $Val extends ChatGroup>
    implements $ChatGroupCopyWith<$Res> {
  _$ChatGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? memberIds = null,
    Object? adminIds = null,
    Object? createdById = null,
    Object? createdAt = null,
    Object? isChannel = null,
    Object? isEncrypted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      memberIds: null == memberIds
          ? _value.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adminIds: null == adminIds
          ? _value.adminIds
          : adminIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdById: null == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isChannel: null == isChannel
          ? _value.isChannel
          : isChannel // ignore: cast_nullable_to_non_nullable
              as bool,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatGroupImplCopyWith<$Res>
    implements $ChatGroupCopyWith<$Res> {
  factory _$$ChatGroupImplCopyWith(
          _$ChatGroupImpl value, $Res Function(_$ChatGroupImpl) then) =
      __$$ChatGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? imageUrl,
      List<String> memberIds,
      List<String> adminIds,
      String createdById,
      DateTime createdAt,
      bool isChannel,
      bool isEncrypted});
}

/// @nodoc
class __$$ChatGroupImplCopyWithImpl<$Res>
    extends _$ChatGroupCopyWithImpl<$Res, _$ChatGroupImpl>
    implements _$$ChatGroupImplCopyWith<$Res> {
  __$$ChatGroupImplCopyWithImpl(
      _$ChatGroupImpl _value, $Res Function(_$ChatGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? memberIds = null,
    Object? adminIds = null,
    Object? createdById = null,
    Object? createdAt = null,
    Object? isChannel = null,
    Object? isEncrypted = null,
  }) {
    return _then(_$ChatGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      memberIds: null == memberIds
          ? _value._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adminIds: null == adminIds
          ? _value._adminIds
          : adminIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdById: null == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isChannel: null == isChannel
          ? _value.isChannel
          : isChannel // ignore: cast_nullable_to_non_nullable
              as bool,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatGroupImpl implements _ChatGroup {
  const _$ChatGroupImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required final List<String> memberIds,
      required final List<String> adminIds,
      required this.createdById,
      required this.createdAt,
      this.isChannel = false,
      this.isEncrypted = false})
      : _memberIds = memberIds,
        _adminIds = adminIds;

  factory _$ChatGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? imageUrl;
  final List<String> _memberIds;
  @override
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  final List<String> _adminIds;
  @override
  List<String> get adminIds {
    if (_adminIds is EqualUnmodifiableListView) return _adminIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adminIds);
  }

  @override
  final String createdById;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isChannel;
// Telegram-style channel
  @override
  @JsonKey()
  final bool isEncrypted;

  @override
  String toString() {
    return 'ChatGroup(id: $id, name: $name, description: $description, imageUrl: $imageUrl, memberIds: $memberIds, adminIds: $adminIds, createdById: $createdById, createdAt: $createdAt, isChannel: $isChannel, isEncrypted: $isEncrypted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            const DeepCollectionEquality().equals(other._adminIds, _adminIds) &&
            (identical(other.createdById, createdById) ||
                other.createdById == createdById) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isChannel, isChannel) ||
                other.isChannel == isChannel) &&
            (identical(other.isEncrypted, isEncrypted) ||
                other.isEncrypted == isEncrypted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      imageUrl,
      const DeepCollectionEquality().hash(_memberIds),
      const DeepCollectionEquality().hash(_adminIds),
      createdById,
      createdAt,
      isChannel,
      isEncrypted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatGroupImplCopyWith<_$ChatGroupImpl> get copyWith =>
      __$$ChatGroupImplCopyWithImpl<_$ChatGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatGroupImplToJson(
      this,
    );
  }
}

abstract class _ChatGroup implements ChatGroup {
  const factory _ChatGroup(
      {required final String id,
      required final String name,
      required final String? description,
      required final String? imageUrl,
      required final List<String> memberIds,
      required final List<String> adminIds,
      required final String createdById,
      required final DateTime createdAt,
      final bool isChannel,
      final bool isEncrypted}) = _$ChatGroupImpl;

  factory _ChatGroup.fromJson(Map<String, dynamic> json) =
      _$ChatGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  List<String> get memberIds;
  @override
  List<String> get adminIds;
  @override
  String get createdById;
  @override
  DateTime get createdAt;
  @override
  bool get isChannel;
  @override // Telegram-style channel
  bool get isEncrypted;
  @override
  @JsonKey(ignore: true)
  _$$ChatGroupImplCopyWith<_$ChatGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
