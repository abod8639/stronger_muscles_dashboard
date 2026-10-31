// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get email => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @HiveField(5)
  String get preferredLanguage => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get role => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'total_spent')
  double get totalSpent => throw _privateConstructorUsedError;
  @HiveField(10)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(11)
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @HiveField(12)
  List<UserAddress> get addresses => throw _privateConstructorUsedError;
  @HiveField(13)
  @JsonKey(name: 'orders_count')
  int get ordersCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String name,
      @HiveField(2) String? email,
      @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
      @HiveField(4) @JsonKey(name: 'phone_number') String? phoneNumber,
      @HiveField(5) String preferredLanguage,
      @HiveField(6) bool notificationsEnabled,
      @HiveField(7) String? role,
      @HiveField(8) @JsonKey(name: 'is_active') bool isActive,
      @HiveField(9) @JsonKey(name: 'total_spent') double totalSpent,
      @HiveField(10) @JsonKey(name: 'created_at') DateTime? createdAt,
      @HiveField(11) @JsonKey(name: 'last_login') DateTime? lastLogin,
      @HiveField(12) List<UserAddress> addresses,
      @HiveField(13) @JsonKey(name: 'orders_count') int ordersCount});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? preferredLanguage = null,
    Object? notificationsEnabled = null,
    Object? role = freezed,
    Object? isActive = null,
    Object? totalSpent = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? addresses = null,
    Object? ordersCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredLanguage: null == preferredLanguage
          ? _value.preferredLanguage
          : preferredLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<UserAddress>,
      ordersCount: null == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String name,
      @HiveField(2) String? email,
      @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
      @HiveField(4) @JsonKey(name: 'phone_number') String? phoneNumber,
      @HiveField(5) String preferredLanguage,
      @HiveField(6) bool notificationsEnabled,
      @HiveField(7) String? role,
      @HiveField(8) @JsonKey(name: 'is_active') bool isActive,
      @HiveField(9) @JsonKey(name: 'total_spent') double totalSpent,
      @HiveField(10) @JsonKey(name: 'created_at') DateTime? createdAt,
      @HiveField(11) @JsonKey(name: 'last_login') DateTime? lastLogin,
      @HiveField(12) List<UserAddress> addresses,
      @HiveField(13) @JsonKey(name: 'orders_count') int ordersCount});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? preferredLanguage = null,
    Object? notificationsEnabled = null,
    Object? role = freezed,
    Object? isActive = null,
    Object? totalSpent = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? addresses = null,
    Object? ordersCount = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredLanguage: null == preferredLanguage
          ? _value.preferredLanguage
          : preferredLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<UserAddress>,
      ordersCount: null == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) this.email,
      @HiveField(3) @JsonKey(name: 'photo_url') this.photoUrl,
      @HiveField(4) @JsonKey(name: 'phone_number') this.phoneNumber,
      @HiveField(5) this.preferredLanguage = 'ar',
      @HiveField(6) this.notificationsEnabled = true,
      @HiveField(7) this.role = 'user',
      @HiveField(8) @JsonKey(name: 'is_active') this.isActive = true,
      @HiveField(9) @JsonKey(name: 'total_spent') this.totalSpent = 0.0,
      @HiveField(10) @JsonKey(name: 'created_at') this.createdAt,
      @HiveField(11) @JsonKey(name: 'last_login') this.lastLogin,
      @HiveField(12) final List<UserAddress> addresses = const [],
      @HiveField(13) @JsonKey(name: 'orders_count') this.ordersCount = 0})
      : _addresses = addresses,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String? email;
  @override
  @HiveField(3)
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @HiveField(4)
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @JsonKey()
  @HiveField(5)
  final String preferredLanguage;
  @override
  @JsonKey()
  @HiveField(6)
  final bool notificationsEnabled;
  @override
  @JsonKey()
  @HiveField(7)
  final String? role;
  @override
  @HiveField(8)
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @HiveField(9)
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @override
  @HiveField(10)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @HiveField(11)
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  final List<UserAddress> _addresses;
  @override
  @JsonKey()
  @HiveField(12)
  List<UserAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  @HiveField(13)
  @JsonKey(name: 'orders_count')
  final int ordersCount;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photoUrl: $photoUrl, phoneNumber: $phoneNumber, preferredLanguage: $preferredLanguage, notificationsEnabled: $notificationsEnabled, role: $role, isActive: $isActive, totalSpent: $totalSpent, createdAt: $createdAt, lastLogin: $lastLogin, addresses: $addresses, ordersCount: $ordersCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            (identical(other.ordersCount, ordersCount) ||
                other.ordersCount == ordersCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      photoUrl,
      phoneNumber,
      preferredLanguage,
      notificationsEnabled,
      role,
      isActive,
      totalSpent,
      createdAt,
      lastLogin,
      const DeepCollectionEquality().hash(_addresses),
      ordersCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {@HiveField(0) required final int id,
      @HiveField(1) required final String name,
      @HiveField(2) final String? email,
      @HiveField(3) @JsonKey(name: 'photo_url') final String? photoUrl,
      @HiveField(4) @JsonKey(name: 'phone_number') final String? phoneNumber,
      @HiveField(5) final String preferredLanguage,
      @HiveField(6) final bool notificationsEnabled,
      @HiveField(7) final String? role,
      @HiveField(8) @JsonKey(name: 'is_active') final bool isActive,
      @HiveField(9) @JsonKey(name: 'total_spent') final double totalSpent,
      @HiveField(10) @JsonKey(name: 'created_at') final DateTime? createdAt,
      @HiveField(11) @JsonKey(name: 'last_login') final DateTime? lastLogin,
      @HiveField(12) final List<UserAddress> addresses,
      @HiveField(13)
      @JsonKey(name: 'orders_count')
      final int ordersCount}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String? get email;
  @override
  @HiveField(3)
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @HiveField(4)
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @HiveField(5)
  String get preferredLanguage;
  @override
  @HiveField(6)
  bool get notificationsEnabled;
  @override
  @HiveField(7)
  String? get role;
  @override
  @HiveField(8)
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @HiveField(9)
  @JsonKey(name: 'total_spent')
  double get totalSpent;
  @override
  @HiveField(10)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @HiveField(11)
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  @HiveField(12)
  List<UserAddress> get addresses;
  @override
  @HiveField(13)
  @JsonKey(name: 'orders_count')
  int get ordersCount;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
