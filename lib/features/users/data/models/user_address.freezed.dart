// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) {
  return _UserAddress.fromJson(json);
}

/// @nodoc
mixin _$UserAddress {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get label => throw _privateConstructorUsedError;
  @HiveField(2)
  String get fullName => throw _privateConstructorUsedError;
  @HiveField(3)
  String get phone => throw _privateConstructorUsedError;
  @HiveField(4)
  String get street => throw _privateConstructorUsedError;
  @HiveField(5)
  String get city => throw _privateConstructorUsedError;
  @HiveField(6)
  String get state => throw _privateConstructorUsedError;
  @HiveField(7)
  String get postalCode => throw _privateConstructorUsedError;
  @HiveField(8)
  String get country => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isDefault => throw _privateConstructorUsedError;
  @HiveField(10)
  double? get latitude => throw _privateConstructorUsedError;
  @HiveField(11)
  double? get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAddressCopyWith<UserAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAddressCopyWith<$Res> {
  factory $UserAddressCopyWith(
          UserAddress value, $Res Function(UserAddress) then) =
      _$UserAddressCopyWithImpl<$Res, UserAddress>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String label,
      @HiveField(2) String fullName,
      @HiveField(3) String phone,
      @HiveField(4) String street,
      @HiveField(5) String city,
      @HiveField(6) String state,
      @HiveField(7) String postalCode,
      @HiveField(8) String country,
      @HiveField(9) bool isDefault,
      @HiveField(10) double? latitude,
      @HiveField(11) double? longitude});
}

/// @nodoc
class _$UserAddressCopyWithImpl<$Res, $Val extends UserAddress>
    implements $UserAddressCopyWith<$Res> {
  _$UserAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? country = null,
    Object? isDefault = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAddressImplCopyWith<$Res>
    implements $UserAddressCopyWith<$Res> {
  factory _$$UserAddressImplCopyWith(
          _$UserAddressImpl value, $Res Function(_$UserAddressImpl) then) =
      __$$UserAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String label,
      @HiveField(2) String fullName,
      @HiveField(3) String phone,
      @HiveField(4) String street,
      @HiveField(5) String city,
      @HiveField(6) String state,
      @HiveField(7) String postalCode,
      @HiveField(8) String country,
      @HiveField(9) bool isDefault,
      @HiveField(10) double? latitude,
      @HiveField(11) double? longitude});
}

/// @nodoc
class __$$UserAddressImplCopyWithImpl<$Res>
    extends _$UserAddressCopyWithImpl<$Res, _$UserAddressImpl>
    implements _$$UserAddressImplCopyWith<$Res> {
  __$$UserAddressImplCopyWithImpl(
      _$UserAddressImpl _value, $Res Function(_$UserAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? country = null,
    Object? isDefault = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$UserAddressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAddressImpl extends _UserAddress {
  const _$UserAddressImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.label = '',
      @HiveField(2) this.fullName = '',
      @HiveField(3) this.phone = '',
      @HiveField(4) this.street = '',
      @HiveField(5) this.city = '',
      @HiveField(6) this.state = '',
      @HiveField(7) this.postalCode = '',
      @HiveField(8) this.country = '',
      @HiveField(9) this.isDefault = false,
      @HiveField(10) this.latitude,
      @HiveField(11) this.longitude})
      : super._();

  factory _$UserAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAddressImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @JsonKey()
  @HiveField(1)
  final String label;
  @override
  @JsonKey()
  @HiveField(2)
  final String fullName;
  @override
  @JsonKey()
  @HiveField(3)
  final String phone;
  @override
  @JsonKey()
  @HiveField(4)
  final String street;
  @override
  @JsonKey()
  @HiveField(5)
  final String city;
  @override
  @JsonKey()
  @HiveField(6)
  final String state;
  @override
  @JsonKey()
  @HiveField(7)
  final String postalCode;
  @override
  @JsonKey()
  @HiveField(8)
  final String country;
  @override
  @JsonKey()
  @HiveField(9)
  final bool isDefault;
  @override
  @HiveField(10)
  final double? latitude;
  @override
  @HiveField(11)
  final double? longitude;

  @override
  String toString() {
    return 'UserAddress(id: $id, label: $label, fullName: $fullName, phone: $phone, street: $street, city: $city, state: $state, postalCode: $postalCode, country: $country, isDefault: $isDefault, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, fullName, phone,
      street, city, state, postalCode, country, isDefault, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAddressImplCopyWith<_$UserAddressImpl> get copyWith =>
      __$$UserAddressImplCopyWithImpl<_$UserAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAddressImplToJson(
      this,
    );
  }
}

abstract class _UserAddress extends UserAddress {
  const factory _UserAddress(
      {@HiveField(0) required final String id,
      @HiveField(1) final String label,
      @HiveField(2) final String fullName,
      @HiveField(3) final String phone,
      @HiveField(4) final String street,
      @HiveField(5) final String city,
      @HiveField(6) final String state,
      @HiveField(7) final String postalCode,
      @HiveField(8) final String country,
      @HiveField(9) final bool isDefault,
      @HiveField(10) final double? latitude,
      @HiveField(11) final double? longitude}) = _$UserAddressImpl;
  const _UserAddress._() : super._();

  factory _UserAddress.fromJson(Map<String, dynamic> json) =
      _$UserAddressImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get label;
  @override
  @HiveField(2)
  String get fullName;
  @override
  @HiveField(3)
  String get phone;
  @override
  @HiveField(4)
  String get street;
  @override
  @HiveField(5)
  String get city;
  @override
  @HiveField(6)
  String get state;
  @override
  @HiveField(7)
  String get postalCode;
  @override
  @HiveField(8)
  String get country;
  @override
  @HiveField(9)
  bool get isDefault;
  @override
  @HiveField(10)
  double? get latitude;
  @override
  @HiveField(11)
  double? get longitude;
  @override
  @JsonKey(ignore: true)
  _$$UserAddressImplCopyWith<_$UserAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
