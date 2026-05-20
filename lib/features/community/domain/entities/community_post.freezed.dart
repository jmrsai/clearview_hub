// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommunityPost _$CommunityPostFromJson(Map<String, dynamic> json) {
  return _CommunityPost.fromJson(json);
}

/// @nodoc
mixin _$CommunityPost {
  String get id => throw _privateConstructorUsedError;
  String get communityId => throw _privateConstructorUsedError;
  String? get authorId => throw _privateConstructorUsedError;
  String? get authorName => throw _privateConstructorUsedError;
  String? get authorAvatarUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  int get upvotes => throw _privateConstructorUsedError;
  int get downvotes => throw _privateConstructorUsedError;
  int get comment_count => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // UI Local State
  bool get isUpvotedByMe => throw _privateConstructorUsedError;
  bool get isDownvotedByMe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityPostCopyWith<CommunityPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityPostCopyWith<$Res> {
  factory $CommunityPostCopyWith(
          CommunityPost value, $Res Function(CommunityPost) then) =
      _$CommunityPostCopyWithImpl<$Res, CommunityPost>;
  @useResult
  $Res call(
      {String id,
      String communityId,
      String? authorId,
      String? authorName,
      String? authorAvatarUrl,
      String title,
      String content,
      List<String> imageUrls,
      bool isAnonymous,
      int upvotes,
      int downvotes,
      int comment_count,
      List<String> tags,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isUpvotedByMe,
      bool isDownvotedByMe});
}

/// @nodoc
class _$CommunityPostCopyWithImpl<$Res, $Val extends CommunityPost>
    implements $CommunityPostCopyWith<$Res> {
  _$CommunityPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? communityId = null,
    Object? authorId = freezed,
    Object? authorName = freezed,
    Object? authorAvatarUrl = freezed,
    Object? title = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? isAnonymous = null,
    Object? upvotes = null,
    Object? downvotes = null,
    Object? comment_count = null,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isUpvotedByMe = null,
    Object? isDownvotedByMe = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      communityId: null == communityId
          ? _value.communityId
          : communityId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: freezed == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String?,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as int,
      downvotes: null == downvotes
          ? _value.downvotes
          : downvotes // ignore: cast_nullable_to_non_nullable
              as int,
      comment_count: null == comment_count
          ? _value.comment_count
          : comment_count // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUpvotedByMe: null == isUpvotedByMe
          ? _value.isUpvotedByMe
          : isUpvotedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
      isDownvotedByMe: null == isDownvotedByMe
          ? _value.isDownvotedByMe
          : isDownvotedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityPostImplCopyWith<$Res>
    implements $CommunityPostCopyWith<$Res> {
  factory _$$CommunityPostImplCopyWith(
          _$CommunityPostImpl value, $Res Function(_$CommunityPostImpl) then) =
      __$$CommunityPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String communityId,
      String? authorId,
      String? authorName,
      String? authorAvatarUrl,
      String title,
      String content,
      List<String> imageUrls,
      bool isAnonymous,
      int upvotes,
      int downvotes,
      int comment_count,
      List<String> tags,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isUpvotedByMe,
      bool isDownvotedByMe});
}

/// @nodoc
class __$$CommunityPostImplCopyWithImpl<$Res>
    extends _$CommunityPostCopyWithImpl<$Res, _$CommunityPostImpl>
    implements _$$CommunityPostImplCopyWith<$Res> {
  __$$CommunityPostImplCopyWithImpl(
      _$CommunityPostImpl _value, $Res Function(_$CommunityPostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? communityId = null,
    Object? authorId = freezed,
    Object? authorName = freezed,
    Object? authorAvatarUrl = freezed,
    Object? title = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? isAnonymous = null,
    Object? upvotes = null,
    Object? downvotes = null,
    Object? comment_count = null,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isUpvotedByMe = null,
    Object? isDownvotedByMe = null,
  }) {
    return _then(_$CommunityPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      communityId: null == communityId
          ? _value.communityId
          : communityId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: freezed == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String?,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as int,
      downvotes: null == downvotes
          ? _value.downvotes
          : downvotes // ignore: cast_nullable_to_non_nullable
              as int,
      comment_count: null == comment_count
          ? _value.comment_count
          : comment_count // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUpvotedByMe: null == isUpvotedByMe
          ? _value.isUpvotedByMe
          : isUpvotedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
      isDownvotedByMe: null == isDownvotedByMe
          ? _value.isDownvotedByMe
          : isDownvotedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityPostImpl implements _CommunityPost {
  const _$CommunityPostImpl(
      {required this.id,
      required this.communityId,
      this.authorId,
      this.authorName,
      this.authorAvatarUrl,
      required this.title,
      required this.content,
      final List<String> imageUrls = const [],
      this.isAnonymous = false,
      this.upvotes = 0,
      this.downvotes = 0,
      this.comment_count = 0,
      final List<String> tags = const [],
      this.createdAt,
      this.updatedAt,
      this.isUpvotedByMe = false,
      this.isDownvotedByMe = false})
      : _imageUrls = imageUrls,
        _tags = tags;

  factory _$CommunityPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityPostImplFromJson(json);

  @override
  final String id;
  @override
  final String communityId;
  @override
  final String? authorId;
  @override
  final String? authorName;
  @override
  final String? authorAvatarUrl;
  @override
  final String title;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  final bool isAnonymous;
  @override
  @JsonKey()
  final int upvotes;
  @override
  @JsonKey()
  final int downvotes;
  @override
  @JsonKey()
  final int comment_count;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// UI Local State
  @override
  @JsonKey()
  final bool isUpvotedByMe;
  @override
  @JsonKey()
  final bool isDownvotedByMe;

  @override
  String toString() {
    return 'CommunityPost(id: $id, communityId: $communityId, authorId: $authorId, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, title: $title, content: $content, imageUrls: $imageUrls, isAnonymous: $isAnonymous, upvotes: $upvotes, downvotes: $downvotes, comment_count: $comment_count, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, isUpvotedByMe: $isUpvotedByMe, isDownvotedByMe: $isDownvotedByMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatarUrl, authorAvatarUrl) ||
                other.authorAvatarUrl == authorAvatarUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.upvotes, upvotes) || other.upvotes == upvotes) &&
            (identical(other.downvotes, downvotes) ||
                other.downvotes == downvotes) &&
            (identical(other.comment_count, comment_count) ||
                other.comment_count == comment_count) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isUpvotedByMe, isUpvotedByMe) ||
                other.isUpvotedByMe == isUpvotedByMe) &&
            (identical(other.isDownvotedByMe, isDownvotedByMe) ||
                other.isDownvotedByMe == isDownvotedByMe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      communityId,
      authorId,
      authorName,
      authorAvatarUrl,
      title,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      isAnonymous,
      upvotes,
      downvotes,
      comment_count,
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      updatedAt,
      isUpvotedByMe,
      isDownvotedByMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      __$$CommunityPostImplCopyWithImpl<_$CommunityPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityPostImplToJson(
      this,
    );
  }
}

abstract class _CommunityPost implements CommunityPost {
  const factory _CommunityPost(
      {required final String id,
      required final String communityId,
      final String? authorId,
      final String? authorName,
      final String? authorAvatarUrl,
      required final String title,
      required final String content,
      final List<String> imageUrls,
      final bool isAnonymous,
      final int upvotes,
      final int downvotes,
      final int comment_count,
      final List<String> tags,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool isUpvotedByMe,
      final bool isDownvotedByMe}) = _$CommunityPostImpl;

  factory _CommunityPost.fromJson(Map<String, dynamic> json) =
      _$CommunityPostImpl.fromJson;

  @override
  String get id;
  @override
  String get communityId;
  @override
  String? get authorId;
  @override
  String? get authorName;
  @override
  String? get authorAvatarUrl;
  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  bool get isAnonymous;
  @override
  int get upvotes;
  @override
  int get downvotes;
  @override
  int get comment_count;
  @override
  List<String> get tags;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override // UI Local State
  bool get isUpvotedByMe;
  @override
  bool get isDownvotedByMe;
  @override
  @JsonKey(ignore: true)
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
