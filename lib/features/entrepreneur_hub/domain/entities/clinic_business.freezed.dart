// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic_business.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClinicBusiness _$ClinicBusinessFromJson(Map<String, dynamic> json) {
  return _ClinicBusiness.fromJson(json);
}

/// @nodoc
mixin _$ClinicBusiness {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get businessType =>
      throw _privateConstructorUsedError; // 'clinic', 'startup', 'optical_store'
  String? get description => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  String? get websiteUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get address => throw _privateConstructorUsedError;
  String get verificationStatus => throw _privateConstructorUsedError;
  String get subscriptionTier => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClinicBusinessCopyWith<ClinicBusiness> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClinicBusinessCopyWith<$Res> {
  factory $ClinicBusinessCopyWith(
          ClinicBusiness value, $Res Function(ClinicBusiness) then) =
      _$ClinicBusinessCopyWithImpl<$Res, ClinicBusiness>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String businessName,
      String businessType,
      String? description,
      String? contactEmail,
      String? contactPhone,
      String? websiteUrl,
      Map<String, dynamic>? address,
      String verificationStatus,
      String subscriptionTier,
      DateTime? createdAt});
}

/// @nodoc
class _$ClinicBusinessCopyWithImpl<$Res, $Val extends ClinicBusiness>
    implements $ClinicBusinessCopyWith<$Res> {
  _$ClinicBusinessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? businessName = null,
    Object? businessType = null,
    Object? description = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? websiteUrl = freezed,
    Object? address = freezed,
    Object? verificationStatus = null,
    Object? subscriptionTier = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessType: null == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionTier: null == subscriptionTier
          ? _value.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClinicBusinessImplCopyWith<$Res>
    implements $ClinicBusinessCopyWith<$Res> {
  factory _$$ClinicBusinessImplCopyWith(_$ClinicBusinessImpl value,
          $Res Function(_$ClinicBusinessImpl) then) =
      __$$ClinicBusinessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String businessName,
      String businessType,
      String? description,
      String? contactEmail,
      String? contactPhone,
      String? websiteUrl,
      Map<String, dynamic>? address,
      String verificationStatus,
      String subscriptionTier,
      DateTime? createdAt});
}

/// @nodoc
class __$$ClinicBusinessImplCopyWithImpl<$Res>
    extends _$ClinicBusinessCopyWithImpl<$Res, _$ClinicBusinessImpl>
    implements _$$ClinicBusinessImplCopyWith<$Res> {
  __$$ClinicBusinessImplCopyWithImpl(
      _$ClinicBusinessImpl _value, $Res Function(_$ClinicBusinessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? businessName = null,
    Object? businessType = null,
    Object? description = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? websiteUrl = freezed,
    Object? address = freezed,
    Object? verificationStatus = null,
    Object? subscriptionTier = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ClinicBusinessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessType: null == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value._address
          : address // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionTier: null == subscriptionTier
          ? _value.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClinicBusinessImpl implements _ClinicBusiness {
  const _$ClinicBusinessImpl(
      {required this.id,
      required this.ownerId,
      required this.businessName,
      required this.businessType,
      this.description,
      this.contactEmail,
      this.contactPhone,
      this.websiteUrl,
      final Map<String, dynamic>? address,
      this.verificationStatus = 'pending',
      this.subscriptionTier = 'free',
      this.createdAt})
      : _address = address;

  factory _$ClinicBusinessImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClinicBusinessImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String businessName;
  @override
  final String businessType;
// 'clinic', 'startup', 'optical_store'
  @override
  final String? description;
  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  final String? websiteUrl;
  final Map<String, dynamic>? _address;
  @override
  Map<String, dynamic>? get address {
    final value = _address;
    if (value == null) return null;
    if (_address is EqualUnmodifiableMapView) return _address;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String verificationStatus;
  @override
  @JsonKey()
  final String subscriptionTier;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ClinicBusiness(id: $id, ownerId: $ownerId, businessName: $businessName, businessType: $businessType, description: $description, contactEmail: $contactEmail, contactPhone: $contactPhone, websiteUrl: $websiteUrl, address: $address, verificationStatus: $verificationStatus, subscriptionTier: $subscriptionTier, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClinicBusinessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            const DeepCollectionEquality().equals(other._address, _address) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.subscriptionTier, subscriptionTier) ||
                other.subscriptionTier == subscriptionTier) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ownerId,
      businessName,
      businessType,
      description,
      contactEmail,
      contactPhone,
      websiteUrl,
      const DeepCollectionEquality().hash(_address),
      verificationStatus,
      subscriptionTier,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClinicBusinessImplCopyWith<_$ClinicBusinessImpl> get copyWith =>
      __$$ClinicBusinessImplCopyWithImpl<_$ClinicBusinessImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClinicBusinessImplToJson(
      this,
    );
  }
}

abstract class _ClinicBusiness implements ClinicBusiness {
  const factory _ClinicBusiness(
      {required final String id,
      required final String ownerId,
      required final String businessName,
      required final String businessType,
      final String? description,
      final String? contactEmail,
      final String? contactPhone,
      final String? websiteUrl,
      final Map<String, dynamic>? address,
      final String verificationStatus,
      final String subscriptionTier,
      final DateTime? createdAt}) = _$ClinicBusinessImpl;

  factory _ClinicBusiness.fromJson(Map<String, dynamic> json) =
      _$ClinicBusinessImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get businessName;
  @override
  String get businessType;
  @override // 'clinic', 'startup', 'optical_store'
  String? get description;
  @override
  String? get contactEmail;
  @override
  String? get contactPhone;
  @override
  String? get websiteUrl;
  @override
  Map<String, dynamic>? get address;
  @override
  String get verificationStatus;
  @override
  String get subscriptionTier;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ClinicBusinessImplCopyWith<_$ClinicBusinessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
