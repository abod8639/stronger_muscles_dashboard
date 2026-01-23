// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) {
  return _DashboardResponse.fromJson(json);
}

/// @nodoc
mixin _$DashboardResponse {
  @JsonKey(name: 'total_users')
  int get totalUsers => throw _privateConstructorUsedError;
  List<DashboardUser> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardResponseCopyWith<DashboardResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardResponseCopyWith<$Res> {
  factory $DashboardResponseCopyWith(
          DashboardResponse value, $Res Function(DashboardResponse) then) =
      _$DashboardResponseCopyWithImpl<$Res, DashboardResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      List<DashboardUser> users});
}

/// @nodoc
class _$DashboardResponseCopyWithImpl<$Res, $Val extends DashboardResponse>
    implements $DashboardResponseCopyWith<$Res> {
  _$DashboardResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<DashboardUser>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardResponseImplCopyWith<$Res>
    implements $DashboardResponseCopyWith<$Res> {
  factory _$$DashboardResponseImplCopyWith(_$DashboardResponseImpl value,
          $Res Function(_$DashboardResponseImpl) then) =
      __$$DashboardResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      List<DashboardUser> users});
}

/// @nodoc
class __$$DashboardResponseImplCopyWithImpl<$Res>
    extends _$DashboardResponseCopyWithImpl<$Res, _$DashboardResponseImpl>
    implements _$$DashboardResponseImplCopyWith<$Res> {
  __$$DashboardResponseImplCopyWithImpl(_$DashboardResponseImpl _value,
      $Res Function(_$DashboardResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? users = null,
  }) {
    return _then(_$DashboardResponseImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<DashboardUser>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardResponseImpl implements _DashboardResponse {
  const _$DashboardResponseImpl(
      {@JsonKey(name: 'total_users') this.totalUsers = 0,
      final List<DashboardUser> users = const []})
      : _users = users;

  factory _$DashboardResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardResponseImplFromJson(json);

  @override
  @JsonKey(name: 'total_users')
  final int totalUsers;
  final List<DashboardUser> _users;
  @override
  @JsonKey()
  List<DashboardUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'DashboardResponse(totalUsers: $totalUsers, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardResponseImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalUsers, const DeepCollectionEquality().hash(_users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardResponseImplCopyWith<_$DashboardResponseImpl> get copyWith =>
      __$$DashboardResponseImplCopyWithImpl<_$DashboardResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardResponseImplToJson(
      this,
    );
  }
}

abstract class _DashboardResponse implements DashboardResponse {
  const factory _DashboardResponse(
      {@JsonKey(name: 'total_users') final int totalUsers,
      final List<DashboardUser> users}) = _$DashboardResponseImpl;

  factory _DashboardResponse.fromJson(Map<String, dynamic> json) =
      _$DashboardResponseImpl.fromJson;

  @override
  @JsonKey(name: 'total_users')
  int get totalUsers;
  @override
  List<DashboardUser> get users;
  @override
  @JsonKey(ignore: true)
  _$$DashboardResponseImplCopyWith<_$DashboardResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardUser _$DashboardUserFromJson(Map<String, dynamic> json) {
  return _DashboardUser.fromJson(json);
}

/// @nodoc
mixin _$DashboardUser {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  double get totalSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  List<UserAddress> get addresses => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_count')
  int get ordersCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardUserCopyWith<DashboardUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardUserCopyWith<$Res> {
  factory $DashboardUserCopyWith(
          DashboardUser value, $Res Function(DashboardUser) then) =
      _$DashboardUserCopyWithImpl<$Res, DashboardUser>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? email,
      String? phone,
      String role,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'photo_url') String? photoUrl,
      @JsonKey(name: 'total_spent') double totalSpent,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      List<UserAddress> addresses,
      @JsonKey(name: 'orders_count') int ordersCount});
}

/// @nodoc
class _$DashboardUserCopyWithImpl<$Res, $Val extends DashboardUser>
    implements $DashboardUserCopyWith<$Res> {
  _$DashboardUserCopyWithImpl(this._value, this._then);

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
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? photoUrl = freezed,
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$DashboardUserImplCopyWith<$Res>
    implements $DashboardUserCopyWith<$Res> {
  factory _$$DashboardUserImplCopyWith(
          _$DashboardUserImpl value, $Res Function(_$DashboardUserImpl) then) =
      __$$DashboardUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? email,
      String? phone,
      String role,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'photo_url') String? photoUrl,
      @JsonKey(name: 'total_spent') double totalSpent,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      List<UserAddress> addresses,
      @JsonKey(name: 'orders_count') int ordersCount});
}

/// @nodoc
class __$$DashboardUserImplCopyWithImpl<$Res>
    extends _$DashboardUserCopyWithImpl<$Res, _$DashboardUserImpl>
    implements _$$DashboardUserImplCopyWith<$Res> {
  __$$DashboardUserImplCopyWithImpl(
      _$DashboardUserImpl _value, $Res Function(_$DashboardUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? photoUrl = freezed,
    Object? totalSpent = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? addresses = null,
    Object? ordersCount = null,
  }) {
    return _then(_$DashboardUserImpl(
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$DashboardUserImpl extends _DashboardUser {
  const _$DashboardUserImpl(
      {required this.id,
      this.name = '',
      this.email,
      this.phone,
      this.role = 'customer',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'photo_url') this.photoUrl,
      @JsonKey(name: 'total_spent') this.totalSpent = 0.0,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'last_login') this.lastLogin,
      final List<UserAddress> addresses = const [],
      @JsonKey(name: 'orders_count') this.ordersCount = 0})
      : _addresses = addresses,
        super._();

  factory _$DashboardUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardUserImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  final List<UserAddress> _addresses;
  @override
  @JsonKey()
  List<UserAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  @JsonKey(name: 'orders_count')
  final int ordersCount;

  @override
  String toString() {
    return 'DashboardUser(id: $id, name: $name, email: $email, phone: $phone, role: $role, isActive: $isActive, photoUrl: $photoUrl, totalSpent: $totalSpent, createdAt: $createdAt, lastLogin: $lastLogin, addresses: $addresses, ordersCount: $ordersCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
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
      phone,
      role,
      isActive,
      photoUrl,
      totalSpent,
      createdAt,
      lastLogin,
      const DeepCollectionEquality().hash(_addresses),
      ordersCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardUserImplCopyWith<_$DashboardUserImpl> get copyWith =>
      __$$DashboardUserImplCopyWithImpl<_$DashboardUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardUserImplToJson(
      this,
    );
  }
}

abstract class _DashboardUser extends DashboardUser {
  const factory _DashboardUser(
          {required final int id,
          final String name,
          final String? email,
          final String? phone,
          final String role,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'photo_url') final String? photoUrl,
          @JsonKey(name: 'total_spent') final double totalSpent,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'last_login') final DateTime? lastLogin,
          final List<UserAddress> addresses,
          @JsonKey(name: 'orders_count') final int ordersCount}) =
      _$DashboardUserImpl;
  const _DashboardUser._() : super._();

  factory _DashboardUser.fromJson(Map<String, dynamic> json) =
      _$DashboardUserImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String get role;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'total_spent')
  double get totalSpent;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  List<UserAddress> get addresses;
  @override
  @JsonKey(name: 'orders_count')
  int get ordersCount;
  @override
  @JsonKey(ignore: true)
  _$$DashboardUserImplCopyWith<_$DashboardUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
