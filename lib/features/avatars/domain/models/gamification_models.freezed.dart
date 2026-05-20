// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get iconUrl => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;
  DateTime? get unlockedAt => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
          Achievement value, $Res Function(Achievement) then) =
      _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String iconUrl,
      bool isUnlocked,
      DateTime? unlockedAt,
      int xpReward});
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconUrl = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? xpReward = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
          _$AchievementImpl value, $Res Function(_$AchievementImpl) then) =
      __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String iconUrl,
      bool isUnlocked,
      DateTime? unlockedAt,
      int xpReward});
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
      _$AchievementImpl _value, $Res Function(_$AchievementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconUrl = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? xpReward = null,
  }) {
    return _then(_$AchievementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.iconUrl,
      this.isUnlocked = false,
      this.unlockedAt,
      this.xpReward = 0});

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String iconUrl;
  @override
  @JsonKey()
  final bool isUnlocked;
  @override
  final DateTime? unlockedAt;
  @override
  @JsonKey()
  final int xpReward;

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, iconUrl: $iconUrl, isUnlocked: $isUnlocked, unlockedAt: $unlockedAt, xpReward: $xpReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, iconUrl,
      isUnlocked, unlockedAt, xpReward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(
      this,
    );
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement(
      {required final String id,
      required final String title,
      required final String description,
      required final String iconUrl,
      final bool isUnlocked,
      final DateTime? unlockedAt,
      final int xpReward}) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get iconUrl;
  @override
  bool get isUnlocked;
  @override
  DateTime? get unlockedAt;
  @override
  int get xpReward;
  @override
  @JsonKey(ignore: true)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  String get userId => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get currentXp => throw _privateConstructorUsedError;
  int get nextLevelXp => throw _privateConstructorUsedError;
  int get totalBlinks => throw _privateConstructorUsedError;
  int get totalExercisesDone => throw _privateConstructorUsedError;
  int get dailyStreak => throw _privateConstructorUsedError;
  List<String> get unlockedAchievementIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {String userId,
      int level,
      int currentXp,
      int nextLevelXp,
      int totalBlinks,
      int totalExercisesDone,
      int dailyStreak,
      List<String> unlockedAchievementIds});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? level = null,
    Object? currentXp = null,
    Object? nextLevelXp = null,
    Object? totalBlinks = null,
    Object? totalExercisesDone = null,
    Object? dailyStreak = null,
    Object? unlockedAchievementIds = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      currentXp: null == currentXp
          ? _value.currentXp
          : currentXp // ignore: cast_nullable_to_non_nullable
              as int,
      nextLevelXp: null == nextLevelXp
          ? _value.nextLevelXp
          : nextLevelXp // ignore: cast_nullable_to_non_nullable
              as int,
      totalBlinks: null == totalBlinks
          ? _value.totalBlinks
          : totalBlinks // ignore: cast_nullable_to_non_nullable
              as int,
      totalExercisesDone: null == totalExercisesDone
          ? _value.totalExercisesDone
          : totalExercisesDone // ignore: cast_nullable_to_non_nullable
              as int,
      dailyStreak: null == dailyStreak
          ? _value.dailyStreak
          : dailyStreak // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedAchievementIds: null == unlockedAchievementIds
          ? _value.unlockedAchievementIds
          : unlockedAchievementIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int level,
      int currentXp,
      int nextLevelXp,
      int totalBlinks,
      int totalExercisesDone,
      int dailyStreak,
      List<String> unlockedAchievementIds});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? level = null,
    Object? currentXp = null,
    Object? nextLevelXp = null,
    Object? totalBlinks = null,
    Object? totalExercisesDone = null,
    Object? dailyStreak = null,
    Object? unlockedAchievementIds = null,
  }) {
    return _then(_$UserStatsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      currentXp: null == currentXp
          ? _value.currentXp
          : currentXp // ignore: cast_nullable_to_non_nullable
              as int,
      nextLevelXp: null == nextLevelXp
          ? _value.nextLevelXp
          : nextLevelXp // ignore: cast_nullable_to_non_nullable
              as int,
      totalBlinks: null == totalBlinks
          ? _value.totalBlinks
          : totalBlinks // ignore: cast_nullable_to_non_nullable
              as int,
      totalExercisesDone: null == totalExercisesDone
          ? _value.totalExercisesDone
          : totalExercisesDone // ignore: cast_nullable_to_non_nullable
              as int,
      dailyStreak: null == dailyStreak
          ? _value.dailyStreak
          : dailyStreak // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedAchievementIds: null == unlockedAchievementIds
          ? _value._unlockedAchievementIds
          : unlockedAchievementIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl(
      {required this.userId,
      this.level = 1,
      this.currentXp = 0,
      this.nextLevelXp = 1000,
      this.totalBlinks = 0,
      this.totalExercisesDone = 0,
      this.dailyStreak = 0,
      final List<String> unlockedAchievementIds = const []})
      : _unlockedAchievementIds = unlockedAchievementIds;

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int currentXp;
  @override
  @JsonKey()
  final int nextLevelXp;
  @override
  @JsonKey()
  final int totalBlinks;
  @override
  @JsonKey()
  final int totalExercisesDone;
  @override
  @JsonKey()
  final int dailyStreak;
  final List<String> _unlockedAchievementIds;
  @override
  @JsonKey()
  List<String> get unlockedAchievementIds {
    if (_unlockedAchievementIds is EqualUnmodifiableListView)
      return _unlockedAchievementIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedAchievementIds);
  }

  @override
  String toString() {
    return 'UserStats(userId: $userId, level: $level, currentXp: $currentXp, nextLevelXp: $nextLevelXp, totalBlinks: $totalBlinks, totalExercisesDone: $totalExercisesDone, dailyStreak: $dailyStreak, unlockedAchievementIds: $unlockedAchievementIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.currentXp, currentXp) ||
                other.currentXp == currentXp) &&
            (identical(other.nextLevelXp, nextLevelXp) ||
                other.nextLevelXp == nextLevelXp) &&
            (identical(other.totalBlinks, totalBlinks) ||
                other.totalBlinks == totalBlinks) &&
            (identical(other.totalExercisesDone, totalExercisesDone) ||
                other.totalExercisesDone == totalExercisesDone) &&
            (identical(other.dailyStreak, dailyStreak) ||
                other.dailyStreak == dailyStreak) &&
            const DeepCollectionEquality().equals(
                other._unlockedAchievementIds, _unlockedAchievementIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      level,
      currentXp,
      nextLevelXp,
      totalBlinks,
      totalExercisesDone,
      dailyStreak,
      const DeepCollectionEquality().hash(_unlockedAchievementIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats(
      {required final String userId,
      final int level,
      final int currentXp,
      final int nextLevelXp,
      final int totalBlinks,
      final int totalExercisesDone,
      final int dailyStreak,
      final List<String> unlockedAchievementIds}) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  String get userId;
  @override
  int get level;
  @override
  int get currentXp;
  @override
  int get nextLevelXp;
  @override
  int get totalBlinks;
  @override
  int get totalExercisesDone;
  @override
  int get dailyStreak;
  @override
  List<String> get unlockedAchievementIds;
  @override
  @JsonKey(ignore: true)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
