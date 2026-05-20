// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicationReminder _$MedicationReminderFromJson(Map<String, dynamic> json) {
  return _MedicationReminder.fromJson(json);
}

/// @nodoc
mixin _$MedicationReminder {
  String get id => throw _privateConstructorUsedError;
  String get medicationName => throw _privateConstructorUsedError;
  String get dosage => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<DateTime> get history => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MedicationReminderCopyWith<MedicationReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationReminderCopyWith<$Res> {
  factory $MedicationReminderCopyWith(
          MedicationReminder value, $Res Function(MedicationReminder) then) =
      _$MedicationReminderCopyWithImpl<$Res, MedicationReminder>;
  @useResult
  $Res call(
      {String id,
      String medicationName,
      String dosage,
      DateTime time,
      bool isActive,
      List<DateTime> history});
}

/// @nodoc
class _$MedicationReminderCopyWithImpl<$Res, $Val extends MedicationReminder>
    implements $MedicationReminderCopyWith<$Res> {
  _$MedicationReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medicationName = null,
    Object? dosage = null,
    Object? time = null,
    Object? isActive = null,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medicationName: null == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicationReminderImplCopyWith<$Res>
    implements $MedicationReminderCopyWith<$Res> {
  factory _$$MedicationReminderImplCopyWith(_$MedicationReminderImpl value,
          $Res Function(_$MedicationReminderImpl) then) =
      __$$MedicationReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String medicationName,
      String dosage,
      DateTime time,
      bool isActive,
      List<DateTime> history});
}

/// @nodoc
class __$$MedicationReminderImplCopyWithImpl<$Res>
    extends _$MedicationReminderCopyWithImpl<$Res, _$MedicationReminderImpl>
    implements _$$MedicationReminderImplCopyWith<$Res> {
  __$$MedicationReminderImplCopyWithImpl(_$MedicationReminderImpl _value,
      $Res Function(_$MedicationReminderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medicationName = null,
    Object? dosage = null,
    Object? time = null,
    Object? isActive = null,
    Object? history = null,
  }) {
    return _then(_$MedicationReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medicationName: null == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicationReminderImpl implements _MedicationReminder {
  const _$MedicationReminderImpl(
      {required this.id,
      required this.medicationName,
      required this.dosage,
      required this.time,
      this.isActive = true,
      final List<DateTime> history = const []})
      : _history = history;

  factory _$MedicationReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicationReminderImplFromJson(json);

  @override
  final String id;
  @override
  final String medicationName;
  @override
  final String dosage;
  @override
  final DateTime time;
  @override
  @JsonKey()
  final bool isActive;
  final List<DateTime> _history;
  @override
  @JsonKey()
  List<DateTime> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'MedicationReminder(id: $id, medicationName: $medicationName, dosage: $dosage, time: $time, isActive: $isActive, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.medicationName, medicationName) ||
                other.medicationName == medicationName) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, medicationName, dosage, time,
      isActive, const DeepCollectionEquality().hash(_history));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationReminderImplCopyWith<_$MedicationReminderImpl> get copyWith =>
      __$$MedicationReminderImplCopyWithImpl<_$MedicationReminderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicationReminderImplToJson(
      this,
    );
  }
}

abstract class _MedicationReminder implements MedicationReminder {
  const factory _MedicationReminder(
      {required final String id,
      required final String medicationName,
      required final String dosage,
      required final DateTime time,
      final bool isActive,
      final List<DateTime> history}) = _$MedicationReminderImpl;

  factory _MedicationReminder.fromJson(Map<String, dynamic> json) =
      _$MedicationReminderImpl.fromJson;

  @override
  String get id;
  @override
  String get medicationName;
  @override
  String get dosage;
  @override
  DateTime get time;
  @override
  bool get isActive;
  @override
  List<DateTime> get history;
  @override
  @JsonKey(ignore: true)
  _$$MedicationReminderImplCopyWith<_$MedicationReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
